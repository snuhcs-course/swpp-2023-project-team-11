import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mobile_app/app/data/dio_instance.dart';
import 'package:mobile_app/app/domain/models/intimacy.dart';
import 'package:mobile_app/app/domain/models/topic.dart';
import 'package:mobile_app/app/domain/repository_interfaces/roadmap_repository.dart';
import 'package:mobile_app/app/domain/result.dart';
import 'package:mobile_app/core/constants/environment.dart';

class RoadmapRepositoryImpl implements RoadmapRepository {
  @override
  Future<Result<List<Topic>, DefaultIssue>> readTopics(
      {required int chattingRoomId}) async {
    final Dio dio = DioInstance.getDio;
    const path = "/chatting/topic";

    try {
      final response = await dio.get<String>(
          baseUrl + path,
          queryParameters: {"chatting_id": chattingRoomId, "limit": 3},
        options: Options(headers: {'accept': 'application/json'})
      );
      final data = response.data;
      if (data == null) throw Exception();

      print(response.data);
      Iterable l = json.decode(response.data!);

      List<Topic> topics = List<Topic>.from(l.map((element) => Topic.fromJson(element)));
      return Result.success(topics);
    } on DioException catch (e) {
      // 이걸로 분기를 해서 대응해라
      final statusCode = e.response?.statusCode;
      print("로드맵 주제 추천 통신 에러 발생 $statusCode, data : ${e.response?.data}");
      return Result.fail(DefaultIssue.badRequest);
    } catch (e, s) {
      print("알 수 없는 에러 발생");
      print(e);
      print(s);
      return Result.fail(DefaultIssue.unknown);
    }
  }

  @override
  Future<Result<Intimacy, DefaultIssue>> updateIntimacy(
      {required int chattingRoomId}) async {
    final Dio dio = DioInstance.getDio;
    const path = "/chatting/intimacy";
    print(chattingRoomId);

    try {
      final response = await dio.post<Map<String, dynamic>>(baseUrl + path,
          queryParameters: {"chatting_id": chattingRoomId});
      final data = response.data;
      if (data == null) throw Exception();

      print(response.data);

      Intimacy intimacy = Intimacy.fromJson(data);
      return Result.success(intimacy);
    } on DioException catch (e) {
      // 이걸로 분기를 해서 대응해라
      final statusCode = e.response?.statusCode;
      print("친밀도 통신 에러 발생 $statusCode, data : ${e.response?.data}");
      return Result.fail(DefaultIssue.badRequest);
    } catch (e, s) {
      print("알 수 없는 에러 발생");
      print(e);
      print(s);
      return Result.fail(DefaultIssue.unknown);
    }
  }
}
