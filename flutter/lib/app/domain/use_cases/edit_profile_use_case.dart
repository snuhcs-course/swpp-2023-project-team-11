

import 'package:mobile_app/app/domain/repository_interfaces/user_repository.dart';
import 'package:mobile_app/app/domain/result.dart';

class EditProfileUseCase{
  final UserRepository _userRepository;

  Future<void> call(Map<String, dynamic> createData, Map<String, dynamic> deleteData, void Function() onSuccess, void Function() onFail) async {
    final editProfileResult = await _userRepository.editUserProfile(createData: createData, deleteData: deleteData);

    switch (editProfileResult) {
      case Success(:final data):{
        onSuccess();
      }case Fail(:final issue):{
        onFail();
    }
    }
  }

  const EditProfileUseCase({
    required UserRepository userRepository,
  }) : _userRepository = userRepository;
}