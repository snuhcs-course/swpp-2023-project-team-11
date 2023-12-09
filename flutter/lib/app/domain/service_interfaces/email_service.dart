import 'package:mobile_app/app/domain/result.dart';

abstract class EmailService {
  /// API : 이메일을 인증 서비스(외부 서비스 이용 필요)를 이용하여 이메일 코드 전송을 요청
  /// endPoint : service/email-code-request
  ///
  /// <request>
  /// - email
  /// <response>
  /// - 아마 추후 코드 인증 결과 매칭하려고 식별자 스트링으로 하나 줄 삘
  Future<Result<String, DefaultIssue>> requestEmail({required String email});

  /// API :
  /// endPoint : service/email-code-verify
  ///
  /// <request>
  /// - verifyToken - 인증 식별
  /// - emailCode
  /// <response>
  /// - 성공인지 실패인지 알 수 있는 결과
  Future<Result<EmailAuthResult, DefaultIssue>> verifyEmailCode({required String email, required int emailCode});
}

class EmailAuthResult {
  final String token;
  final bool authResult;

  const EmailAuthResult({
    required this.token,
    required this.authResult,
  });
}