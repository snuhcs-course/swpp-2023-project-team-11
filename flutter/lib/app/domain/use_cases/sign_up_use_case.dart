import 'package:mobile_app/app/domain/service_interfaces/auth_service.dart';

class SignUpUseCase {
  final AuthService _authService;

  Future<void> call() async {

  }

  const SignUpUseCase({
    required AuthService authService,
  }) : _authService = authService;
}