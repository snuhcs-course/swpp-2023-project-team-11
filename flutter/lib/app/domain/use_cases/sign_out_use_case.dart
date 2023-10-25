import 'package:mobile_app/app/domain/service_interfaces/auth_service.dart';

class SignOutUseCase{
  final AuthService _authService;

  Future<void> call({required void Function() onSuccess}) async {
    await _authService.expireSession();
    await _authService.setUnauthorized();

    onSuccess();

  }

  const SignOutUseCase({
    required AuthService authService,
  }) : _authService = authService;
}