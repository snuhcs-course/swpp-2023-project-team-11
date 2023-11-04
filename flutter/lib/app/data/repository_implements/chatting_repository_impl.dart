import 'package:dio/dio.dart';
import 'package:mobile_app/app/data/dio_instance.dart';
import 'package:mobile_app/app/domain/models/chatting_room.dart';
import 'package:mobile_app/app/domain/repository_interfaces/chatting_room_repository.dart';
import 'package:mobile_app/app/domain/result.dart';
import 'package:mobile_app/core/constants/environment.dart';

class ChattingRepositoryImpl implements ChattingRepository {
  @override
  Future<Result<List<ChattingRoom>, DefaultIssue>> readAllWhereApproved() async {
    final Dio dio = DioInstance.getDio;
    const path = "/chatting/";
    try {
      final response = await dio.get<List<dynamic>>(baseUrl + path, queryParameters: {"is_approved" : true});
      final data = response.data;
      if (data== null) throw Exception("데이터가 Null");
      final chattingRooms = data.map((e) => ChattingRoom.fromJson(e)).toList();
      return Result.success(chattingRooms);
    } on DioException catch (e) {
      print("에러 발생");
      print(e.response?.statusCode);
      print(e.response?.data);
      return Result.fail(DefaultIssue.badRequest);
    } catch (e) {

      return Result.fail(DefaultIssue.badRequest);
    }
  }

  @override
  Future<Result<List<ChattingRoom>, DefaultIssue>> readAllWhereNotApproved() async {
    final Dio dio = DioInstance.getDio;
    const path = "/chatting/";
    try {
      final response = await dio.get<List<dynamic>>(baseUrl + path, queryParameters: {"is_approved" : false});
      final data = response.data;
      if (data== null) throw Exception("데이터가 Null");
      final chattingRooms = data.map((e) => ChattingRoom.fromJson(e)).toList();
      return Result.success(chattingRooms);
    } on DioException catch (e) {
      print("에러 발생");
      print(e.response?.statusCode);
      print(e.response?.data);
      return Result.fail(DefaultIssue.badRequest);
    } catch (e) {

      return Result.fail(DefaultIssue.badRequest);
    }
  }

  @override
  Future<Result<ChattingRoom, DefaultIssue>> createChattingRoom({required String counterPartEmail}) async {
    final Dio dio = DioInstance.getDio;
    const path = "/chatting/";
    try {
      final response = await dio.post(baseUrl + path, data: {
        "counterpart" : counterPartEmail,
      });
      final data = response.data;
      if (data== null) throw Exception("데이터가 Null");
      final chattingRoom = ChattingRoom.fromJson(data);
      return Result.success(chattingRoom);
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

}