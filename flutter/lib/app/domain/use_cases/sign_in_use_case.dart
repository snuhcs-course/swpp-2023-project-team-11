import 'package:mobile_app/app/domain/repository_interfaces/user_repository.dart';
import 'package:mobile_app/app/domain/service_interfaces/auth_service.dart';

class SignInUseCase {
  final AuthService _authService;
  final UserRepository _userRepository;

  Future<void> call() async  {

  }

  const SignInUseCase({
    required AuthService authService,
    required UserRepository userRepository,
  }) : _authService = authService, _userRepository = userRepository;
}