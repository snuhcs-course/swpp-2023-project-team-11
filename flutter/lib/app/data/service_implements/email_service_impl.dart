

import 'package:dio/dio.dart';
import 'package:mobile_app/app/domain/result.dart';
import 'package:mobile_app/app/domain/service_interfaces/email_service.dart';
import 'package:mobile_app/core/constants/environment.dart';

import '../dio_instance.dart';

class EmailServiceImpl implements EmailService{

  @override
  Future<Result<String, DefaultIssue>> requestEmail({required String email}) async {
    final Dio dio = DioInstance.getDio;
    const path = '/user/email/code';

    try{
      final response = await dio.post<String>(Environment.baseUrl + path, data: {"email": email});
      final data = response.data;
      if (data == null) throw Exception();
      return Result.success(data);
    } on DioException catch(e) {
      final statusCode = e.response?.statusCode;
      print("통신 에러 발생 $statusCode, data : ${e.response?.data}");
      return Result.fail(DefaultIssue.badRequest);
    } catch (e) {
      print("알 수 없는 에러 발생");
      return Result.fail(DefaultIssue.badRequest);
    }
  }

  @override
  Future<Result<EmailAuthResult, DefaultIssue>> verifyEmailCode({required String email, required int emailCode}) async {
    final Dio dio = DioInstance.getDio;
    const path = "/user/email/verify";

    try{
      final response = await dio.post<Map<String, dynamic>>(Environment.baseUrl + path, data: {"email": email, "code": emailCode});
      final data = response.data;
      if (data == null) throw Exception();
      // at this point, the code was correct and email token is returned.
      final emailAuthResult = EmailAuthResult(token: data["token"], authResult: true);
      return Result.success(emailAuthResult);
    } on DioException catch(e) {
      final statusCode = e.response?.statusCode;
      print("통신 에러 발생 $statusCode, data : ${e.response?.data}");
      return Result.fail(DefaultIssue.badRequest);
    } catch (e) {
      print("알 수 없는 에러 발생");
      return Result.fail(DefaultIssue.badRequest);
    }



  }

}