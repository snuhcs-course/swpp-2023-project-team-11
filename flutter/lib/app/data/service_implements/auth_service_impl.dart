import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_app/app/domain/result.dart';
import 'package:mobile_app/app/domain/service_interfaces/auth_service.dart';

class AuthServiceImpl implements AuthService {
  final _authStorage = const FlutterSecureStorage();
  @override
  Future<Result<String, SignInIssue>> signIn({
    required String signInId,
    required String password,
  }) async {
    if (signInId=="test" && password =="test") {
      const String mockUserId = "userId";
      const String mockUserAccess = "userAccess";
      await _saveAuthInLocal(mockUserAccess);
      return Result.success(mockUserId);
    }
    return Result.fail(SignInIssue.badRequest);
  }

  Future<void> _saveAuthInLocal(String access) async {
    await _authStorage.write(key: "access", value: access);
  }

  Future<void> _deleteAuthInLocal() async  {
    await _authStorage.delete(key: 'access');
  }
}
