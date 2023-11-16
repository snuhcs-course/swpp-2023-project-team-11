import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
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

  @override
  StreamSubscription initChatConnection({
    required String sessionKey,
    required void Function(Chat chat) onMessageChatReceive,
  }) {
    cachedSessionKey = sessionKey;
    chatSocketChannel = WebSocketChannel.connect(Uri.parse(_chatWebSocketUrl));
    cachedOnData = (event) {
      final decoded = jsonDecode(event);

      print("data layer : socket received $decoded");
      if (decoded["type"] == "system") {
        print("system message : ${decoded["body"]}");
      }
      if (decoded["type"] == "message") {
        print("message type received");
        final body = decoded["body"];
        final chat = Chat.fromJson(body);
        onMessageChatReceive(chat);
      }
    };
    final subscription = chatSocketChannel!.stream.listen(cachedOnData, onError: (e, s) {
      print("socket error");
    }, onDone: () {
      print("socket done");
      print(DateTime.now());
      print("------------");
    });
    chatSocketChannel!.sink.add(jsonEncode({
      "type": "system",
      "body": {"session_key": sessionKey}
    }));
    print(sessionKey);
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
        baseUrl + path,
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
  Future<void> sendChat({required String chatText, required String chattingRoomId}) async {
    chatSocketChannel!.sink.add(jsonEncode(
      {
        "type": "message",
        "body": {
          "chatting_id": chattingRoomId,
          "msg": chatText,
        },
      },
    ));
  }

  Future<void> reConnect() async {
    if (cachedSubscription != null) {
      chatSocketChannel = WebSocketChannel.connect(Uri.parse(_chatWebSocketUrl));
      cachedSubscription!.pause();
      await cachedSubscription!.cancel();
      cachedSubscription = chatSocketChannel!.stream.listen(cachedOnData);
      chatSocketChannel!.sink.add(jsonEncode({
        "type": "system",
        "body": {"session_key": cachedSessionKey}
      }));
    }
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
