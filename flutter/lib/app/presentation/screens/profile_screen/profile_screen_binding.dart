import 'package:get/instance_manager.dart';
import 'package:mobile_app/app/data/repository_implements/user_repository_impl.dart';
import 'package:mobile_app/app/data/service_implements/auth_service_impl.dart';
import 'package:mobile_app/app/domain/use_cases/edit_profile_use_case.dart';
import 'package:mobile_app/app/domain/use_cases/sign_out_use_case.dart';
import 'profile_screen_controller.dart';

class ProfileScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(ProfileScreenController(
      signOutUseCase: SignOutUseCase(authService: AuthServiceImpl()), editProfileUseCase: EditProfileUseCase(userRepository: UserRepositoryImpl())
    ));
  }
}