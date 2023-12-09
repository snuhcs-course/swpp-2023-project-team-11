import 'package:get/instance_manager.dart';
import 'package:mobile_app/app/data/repository_implements/user_repository_impl.dart';
import 'package:mobile_app/app/data/service_implements/auth_service_impl.dart';
import 'package:mobile_app/app/domain/use_cases/automatic_sign_in_use_case.dart';
import 'package:mobile_app/dependency_manager.dart';
import 'splash_screen_controller.dart';

class SplashScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(SplashScreenController(
        automaticSignInUseCase: AutomaticSignInUseCase(
      userRepository: UserRepositoryImpl(),
      authService: Get.find<DependencyManager>().authService,
    )));
  }
}
