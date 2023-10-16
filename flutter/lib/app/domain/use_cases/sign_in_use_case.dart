import 'package:mobile_app/app/domain/service_interfaces/auth_service.dart';

class SignInUseCase {
  final AuthService _authService;

  Future<void> call() async  {

  }

  const SignInUseCase({
    required AuthService authService,
  }) : _authService = authService;
}