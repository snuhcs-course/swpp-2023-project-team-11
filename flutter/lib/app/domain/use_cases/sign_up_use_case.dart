import 'package:get/get.dart';
import 'package:mobile_app/app/domain/models/user.dart';
import 'package:mobile_app/app/domain/result.dart';
import 'package:mobile_app/app/domain/service_interfaces/auth_service.dart';

class SignUpUseCase {
  final AuthService _authService;

  Future<void> call({
    required String email,
    required String password,
    required User user,
    required String emailToken,
    required void Function() onFail,
    required void Function(User user) onSuccess,
}) async {
    final signUpResult = await _authService.signUp(
      email: email,
      password: password,
      user: user,
      emailToken: emailToken,
    );
    switch(signUpResult) {
      case Success(:final data) : {
        await _authService.setAuthorized(accessToken: data.accessToken);
        onSuccess(user);
      }
      case Fail(:final issue) :{
        onFail();
      }
    }
  }

  const SignUpUseCase({
    required AuthService authService,
  }) : _authService = authService;
}
