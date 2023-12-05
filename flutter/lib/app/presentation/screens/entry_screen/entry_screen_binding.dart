import 'package:get/instance_manager.dart';
import 'package:mobile_app/app/data/repository_implements/user_repository_impl.dart';
import 'package:mobile_app/app/data/service_implements/auth_service_impl.dart';
import 'package:mobile_app/app/domain/use_cases/automatic_sign_in_use_case.dart';
import 'package:mobile_app/app/domain/use_cases/sign_in_use_case.dart';
import 'package:mobile_app/app/domain/use_cases/sign_up_use_case.dart';
import 'package:mobile_app/dependency_manager.dart';
import 'entry_screen_controller.dart';

class EntryScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(
      EntryScreenController(
        signInUseCase: SignInUseCase(
          authService: AuthServiceImpl(),
          userRepository: UserRepositoryImpl(),
        ),
      ),
    );
  }
}
