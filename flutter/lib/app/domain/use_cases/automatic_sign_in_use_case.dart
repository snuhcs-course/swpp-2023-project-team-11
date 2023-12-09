import 'package:mobile_app/app/domain/models/user.dart';
import 'package:mobile_app/app/domain/repository_interfaces/user_repository.dart';
import 'package:mobile_app/app/domain/result.dart';
import 'package:mobile_app/app/domain/service_interfaces/auth_service.dart';

class AutomaticSignInUseCase {
  final UserRepository _userRepository;
  final AuthService _authService;

  Future<void> call({
    required void Function() onFail,
    required void Function(User user) onSuccess,
  }) async {
    print("call automatic");
    final storedSessionKey = await _authService.getSessionKey;
    if (storedSessionKey == null) {
      print("Automatic signin fail. Try signing in");
      onFail();
    }
    else{
      await _authService.setAuthorized(accessToken: storedSessionKey);
      final result = await _userRepository.readUserBySessionId();
      switch (result) {
        case Success(data: final user):
          {
            onSuccess(user);
          }
        case Fail():
          {
            print("Automatic signin fail due to wrong sessionkey. Try signing in");
            onFail();
          }
      }
    }

  }

  AutomaticSignInUseCase({
    required UserRepository userRepository,
    required AuthService authService,
  })  : _userRepository = userRepository,
        _authService = authService;
}
