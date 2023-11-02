import 'package:mobile_app/app/domain/models/user.dart';
import 'package:mobile_app/app/domain/result.dart';

abstract class AuthService {
  /// API : 로그인 기능
  /// endPoint : /auth/sign-in
  ///
  /// <response>
  /// session id를 받습니다
  Future<Result<AccessResult, DefaultIssue>> signIn({
    required String email,
    required String password,
  });

  /// API : 회원가입 기능
  /// endPoint : /auth/sign-up
  ///
  /// <request>
  /// email, password 외에 user를 toJson()해서 보내드리겠습니다. (id는 빼고)
  ///
  /// <response>
  /// session id를 받습니다
  Future<Result<AccessResult, DefaultIssue>> signUp({
    required String email,
    required String password,
    required User user,
    required String emailToken,
  });

  /// API : 발급받은 세션을 expire한다
  /// endPoint : /auth/expire
  ///
  /// <request>
  /// 헤더에 세션 아이디가 담겨있다
  Future<void> expireSession();

  /// 내부 로직
  /// - expireSession 실행 이후 내부 로컬에 저장된 세션 아이디를 삭제한다
  Future<void> setUnauthorized();

  /// 내부 로직
  /// - sign in 혹은 sign up으로 리턴된 session Id를 앞으로 보내는 request에 자동으로 Authroization Header에
  /// 넣어준다
  /// - 보안처리된 로컬 저장소에 sessionId를 저장한다. 추후 앱 재 실행시, 자동으로 로그인될 수 있또록
  Future<void> setAuthorized({required String accessToken});
}

class AccessResult {
  final String accessToken;
  final String tokenType;

  const AccessResult({
    required this.accessToken,
    required this.tokenType,
  });
}
