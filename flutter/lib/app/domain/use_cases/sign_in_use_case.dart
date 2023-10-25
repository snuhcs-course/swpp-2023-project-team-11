import 'package:get/get.dart';
import 'package:mobile_app/app/domain/models/user.dart';
import 'package:mobile_app/app/domain/repository_interfaces/user_repository.dart';
import 'package:mobile_app/app/domain/service_interfaces/auth_service.dart';

import '../result.dart';

class SignInUseCase {
  final AuthService _authService;
  final UserRepository _userRepository;

  Future<void> call({
    required String email,
    required String password,
    required void Function() onFail,
    required void Function() onSuccess,
  }) async {
    final signInResult =
        await _authService.signIn(email: email, password: password);

    switch (signInResult) {
      case Success(:final data):
        {
          await _authService.setAuthorized(accessToken: data.accessToken);
          final result = await _userRepository.readUserBySessionId();
          switch(result) {
            case Success(data : final user) : {
              Get.put(user, permanent: true);
              onSuccess();
            }
            case Fail() : {
              onFail();
            }
          }
        }
      case Fail(:final issue):
        {
          onFail();
        }
    }
  }

  const SignInUseCase({
    required AuthService authService,
    required UserRepository userRepository,
  })  : _authService = authService,
        _userRepository = userRepository;
}
