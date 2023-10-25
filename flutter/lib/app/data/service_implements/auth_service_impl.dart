import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_app/app/data/dio_instance.dart';
import 'package:mobile_app/app/domain/models/user.dart';
import 'package:mobile_app/app/domain/result.dart';
import 'package:mobile_app/app/domain/service_interfaces/auth_service.dart';
import 'package:mobile_app/core/constants/environment.dart';

class AuthServiceImpl implements AuthService {
  final _authStorage = const FlutterSecureStorage();

  Future<void> _saveAuthInLocal(String access) async {
    await _authStorage.write(key: "access", value: access);
  }

  Future<void> _deleteAuthInLocal() async {
    await _authStorage.delete(key: 'access');
  }

  @override
  Future<void> deleteSessionIdInLocal() {
    // TODO: implement deleteSessionIdInLocal
    throw UnimplementedError();
  }

  @override
  Future<void> expireSession() {
    // TODO: implement expireSession
    throw UnimplementedError();
  }

  @override
  Future<void> setAuthorized({required String accessToken}) async {
    const secureStorage = FlutterSecureStorage();
    await secureStorage.write(key: "accessToken", value: accessToken);
    DioInstance.addAuthorizationHeader(accessToken);
  }

  @override
  Future<Result<AccessResult, DefaultIssue>> signUp({
    required String email,
    required String password,
    required User user,
    required String emailToken,
  }) async {
    final Dio dio = DioInstance.getDio;
    const path = '/user/sign_up';
    try  {
      final response = await dio.post<Map<String,dynamic>>(
        baseUrl + path,
        data: {
          "email": email,
          "token": emailToken,
          "password": password,
          "profile": {
            "name": user.name,
            "birth": user.profile.birth,
            "sex": user.profile.sex,
            "major": user.profile.major,
            "admission_year": user.profile.admissionYear,
            "about_me": user.profile.aboutMe,
            "mbti": user.profile.mbti,
            "nation_code": user.getNationCode,
            "foods": user.profile.foodCategories.map((e) => e.name).toList(),
            "movies": user.profile.movieGenres.map((e) => e.name).toList(),
            "hobbies": user.profile.hobbies.map((e) => e.name).toList(),
            "locations": user.profile.locations.map((e) => e.name).toList(),
          },
          "main_language": user.getMainLanguage,
          "languages": user.getLanguages,
        },
      );
      final data = response.data;
      if (data==null) throw Exception();
      final accessToken = data["access_token"];
      final tokenType = data["token_type"];
      final accessResult = AccessResult(accessToken: accessToken, tokenType: tokenType);
      return Result.success(accessResult);
    } on DioException catch(e) {
      // 이걸로 분기를 해서 대응해라
      final statusCode = e.response?.statusCode;
      print("통신 에러 발생 $statusCode, data : ${e.response?.data}");
      return Result.fail(DefaultIssue.badRequest);
    } catch (e) {
      print("알 수 없는 에러 발생");
      return Result.fail(DefaultIssue.badRequest);
    }

  }

  @override
  Future<Result<AccessResult, DefaultIssue>> signIn({required String email, required String password,}) async {
    final Dio dio = DioInstance.getDio;
    const path = "/user/sign_in";

    final response = await dio.post<Map<String, dynamic>>(
      baseUrl + path,
      data: {
        "username": email,
        "password": password
      }
    );

    try {
      final data = response.data;
      if (data == null) throw Exception();
      final accessToken = data["access_token"];
      final tokenType = data["token_type"];
      final accessResult =
          AccessResult(accessToken: accessToken, tokenType: tokenType);
      return Result.success(accessResult);
    } on DioException catch(e){
      final statusCode = e.response?.statusCode;
      print("통신 에러 발생 $statusCode, data : ${e.response?.data}");
      return Result.fail(DefaultIssue.badRequest);
    } catch (e){
      print("알 수 없는 에러 발생");
      return Result.fail(DefaultIssue.badRequest);
    }
  }
}
