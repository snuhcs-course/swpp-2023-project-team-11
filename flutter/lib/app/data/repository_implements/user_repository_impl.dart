import 'package:dio/dio.dart';
import 'package:mobile_app/app/data/dio_instance.dart';
import 'package:mobile_app/app/domain/models/user.dart';
import 'package:mobile_app/app/domain/repository_interfaces/user_repository.dart';
import 'package:mobile_app/app/domain/result.dart';
import 'package:mobile_app/core/constants/environment.dart';

class UserRepositoryImpl implements UserRepository {
  @override
  Future<Result<User, DefaultIssue>> readUserBySessionId() async {
    final Dio dio = DioInstance.getDio;
    const path = "/user/me";
    try{
      final response = await dio.get<Map<String, dynamic>>(
        baseUrl + path
      );
      final data = response.data;
      if (data == null) throw Exception();

      print(response.data);

      User user = User.fromMap(data);
      return Result.success(user);

    } on DioException catch(e) {
      // 이걸로 분기를 해서 대응해라
      final statusCode = e.response?.statusCode;
      print("통신 에러 발생 $statusCode, data : ${e.response?.data}");
      return Result.fail(DefaultIssue.badRequest);
    } catch (e) {
      print("알 수 없는 에러 발생");
      return Result.fail(DefaultIssue.unknown);
    }

  }

  @override
  Future<Result<List<User>, DefaultIssue>> readUsersBasedOnLogic() async {
    final Dio dio = DioInstance.getDio;

    const path = "/user/all";
    print(baseUrl + path);
    try{
      final response = await dio.get(
          baseUrl + path
      );
      final data = response.data as List;
      print("fetch${data}");
      if (data == null) throw Exception();

      List<User> users = [];

      for (var i in data){
        users.add(User.fromMap(i));
      }

      return Result.success(users);

    } on DioException catch(e) {
      // 이걸로 분기를 해서 대응해라
      final statusCode = e.response?.statusCode;
      print("통신 에러 발생 $statusCode, data : ${e.response?.data}");
      return Result.fail(DefaultIssue.badRequest);
    } catch (e) {
      print("알 수 없는 에러 발생");
      return Result.fail(DefaultIssue.unknown);
    }


  }

}