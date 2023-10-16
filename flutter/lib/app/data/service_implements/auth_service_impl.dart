import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_app/app/domain/models/user.dart';
import 'package:mobile_app/app/domain/service_interfaces/auth_service.dart';

class AuthServiceImpl implements AuthService {
  final _authStorage = const FlutterSecureStorage();


  Future<void> _saveAuthInLocal(String access) async {
    await _authStorage.write(key: "access", value: access);
  }

  Future<void> _deleteAuthInLocal() async  {
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
  Future<void> setAuthorized({required String sessionId}) {
    // TODO: implement setAuthorized
    throw UnimplementedError();
  }

  @override
  Future<String> signUp({required String email, required String password, required User user}) {
    // TODO: implement signUp
    throw UnimplementedError();
  }

  @override
  Future<String> signIn({required String email, required String password}) {
    // TODO: implement signIn
    throw UnimplementedError();
  }
}
