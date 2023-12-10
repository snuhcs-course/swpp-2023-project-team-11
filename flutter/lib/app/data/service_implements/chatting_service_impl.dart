import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:mobile_app/app/data/dio_instance.dart';
import 'package:mobile_app/app/domain/models/chat.dart';
import 'package:mobile_app/app/domain/result.dart';
import 'package:mobile_app/app/domain/service_interfaces/chatting_service.dart';
import 'package:mobile_app/core/constants/environment.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChattingServiceImpl implements ChattingService {
  static WebSocketChannel? chatSocketChannel;
  static const _chatWebSocketUrl = "ws://3.35.9.226:8000/ws/connect";
  static String? cachedSessionKey;
  static StreamSubscription? cachedSubscription;
  static void Function(dynamic)? cachedOnData;
  final chatLogger = Logger(
      printer: PrettyPrinter(
    methodCount: 0,
    lineLength: 10,
    printTime: true,
  ));

  @override
  StreamSubscription initChatConnection({
    required String sessionKey,
    required void Function(Chat chat) onMessageChatReceive,
  }) {
    chatLogger.i("init chat connection");
    cachedSessionKey = sessionKey;
    chatSocketChannel = WebSocketChannel.connect(Uri.parse(_chatWebSocketUrl));
    // 소켓의 listener에 넣을 콜백을 미리 정의 및 cache
    cachedOnData = (event) {
      final decoded = jsonDecode(event);
      if (decoded["type"] == "system") {
        chatLogger.i("system text received : ${decoded["body"]}");
      }
      if (decoded["type"] == "message") {
        chatLogger.i("message text received : ${decoded["body"]}");
        final body = decoded["body"];
        final chat = Chat.fromJson(body);
        onMessageChatReceive(chat);
      }
    };
    final subscription =
        chatSocketChannel!.stream.listen(cachedOnData, onError: (e, s) {
      chatLogger.e("socket channel subscription error!");
    }, onDone: () {
      chatLogger.w("socket channel subscription done!");
      reConnect(); // 여기서 리커넥트를 바로 하기? 성공 또는 실패
    });
    // first authentication for 채팅 소켓
    chatSocketChannel!.sink.add(
      jsonEncode(
        {
          "type": "system",
          "body": {"session_key": sessionKey}
        },
      ),
    );
    print(jsonEncode(
      {
        "type": "system",
        "body": {"session_key": sessionKey}
      },
    ));
    chatLogger.i("socket channel authentication send done");
    cachedSubscription = subscription;
    return subscription;
  }

  @override
  Future<Result<List<Chat>, DefaultIssue>> readMessages({
    required String chattingRoomId,
    int? limit,
    int? sequenceId,
  }) async {
    final Dio dio = DioInstance.getDio;
    const path = "/chatting/text";
    try {
      final Map<String, dynamic> params = {
        "chatting_id": chattingRoomId,
      };
      if (limit != null) {
        params["limit"] = limit;
      }
      if (sequenceId != null) {
        params["seq_id"] = sequenceId;
      }
      final response = await dio.get<List<dynamic>>(
        Environment.baseUrl + path,
        queryParameters: params,
      );
      final data = response.data;
      if (data == null) throw Exception("데이터가 Null");
      final chats = data.map((e) => Chat.fromJson(e)).toList();
      return Result.success(chats);
    } on DioException catch (e) {
      print("에러 발생");
      print(e.response?.statusCode);
      print(e.response?.data);
      return Result.fail(DefaultIssue.badRequest);
    } catch (e, s) {
      print(e);
      print(s);
      return Result.fail(DefaultIssue.badRequest);
    }
  }

  @override
  Future<void> sendChat({
    required String chatText,
    required String chattingRoomId,
    required String proxyId,
  }) async {
    final bodyForSendingChat = {
      "type": "message",
      "body": {
        "chatting_id": chattingRoomId,
        "msg": chatText,
        "proxy_id": proxyId
      },
    };
    print(jsonEncode(bodyForSendingChat));
    chatLogger.i("send chat on socketChannel : $bodyForSendingChat");
    chatSocketChannel!.sink.add(jsonEncode(bodyForSendingChat));
  }

  Future<void> reConnect() async {
    // 성공 또는 실패
    chatLogger.i("try socket channel reconnect");
    if (cachedSubscription != null) {
      chatLogger.i("cached Subscription is not null");
      cachedSubscription!.cancel();
      chatLogger.i("cached Subscription cancelled");
    }
    if (chatSocketChannel != null) {
      chatLogger.i("chatSocketChannel is not null");
      chatSocketChannel!.sink.close(); // 네트워크 연결 없이도 성공할 수 있나요? await 빼봤어요
      chatLogger.i("chat socket channel sink closed");
      cachedSubscription = null;
      chatLogger.i("prior subscription cancel fin");
    }

    chatLogger.i("setting up new socket channel...");
    chatSocketChannel =
        WebSocketChannel.connect(Uri.parse(_chatWebSocketUrl)); // 성공 또는 실패

    chatSocketChannel!.ready.then((_) {
      // connection successful
      cachedSubscription =
          chatSocketChannel!.stream.listen(cachedOnData, onError: (e, s) {
        chatLogger.e("socket channel subscription error!");
      }, onDone: () {
        chatLogger.w("socket channel subscription done!!");
        reConnect(); // 여기서 리커넥트를 바로 하기? 성공 또는 실패
      }, cancelOnError: true);
    }).onError((error, stackTrace) {
      chatLogger.w("Couldn't establish connection");
      // chatSocketChannel = null; // 여기서 널로 만들어도 될까요 // chatSOcketChannel, cachedsubscription 둘 다 null인 상태
      Future.delayed(Duration(seconds: 3)).then((value) {
        chatLogger.w("Retrying...");
        reConnect();
      });
    });

    // cachedSubscription = chatSocketChannel!.stream.listen(cachedOnData);
    if (chatSocketChannel != null) {
      chatSocketChannel!.sink.add(jsonEncode({
        "type": "system",
        "body": {"session_key": cachedSessionKey}
      }));
    }

    chatLogger.i("new subscription setting fin");
  }

  @override
  void closeChannel() {
    cachedSubscription!.cancel();
    chatSocketChannel!.sink.close();

    cachedSubscription = null;
    chatSocketChannel = null;
    cachedSessionKey = null;
    cachedOnData = null;
  }
}
