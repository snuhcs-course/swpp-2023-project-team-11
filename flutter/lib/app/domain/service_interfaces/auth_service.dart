import 'package:mobile_app/app/domain/result.dart';

abstract class AuthService {
  Future<Result<String, SignInIssue>> signIn({
    required String signInId,
    required String password,
});
}

enum SignInIssue {
  badRequest,
}