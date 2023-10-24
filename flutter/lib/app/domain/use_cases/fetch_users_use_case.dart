import 'package:mobile_app/app/domain/repository_interfaces/user_repository.dart';
import 'package:mobile_app/app/domain/result.dart';

import '../models/user.dart';

class FetchUsersUseCase {
  final UserRepository _userRepository;

  Future<void> basedOnLogic({
    required void Function(List<User> users) whenSuccess,
    required void Function() whenFail,
  }) async {
    final result = await _userRepository.readUsersBasedOnLogic();
    switch (result) {
      case Success(:final data):
        whenSuccess(data);
      case Fail(:final issue):
        whenFail();
    }
  }

  const FetchUsersUseCase({
    required UserRepository userRepository,
  }) : _userRepository = userRepository;
}
