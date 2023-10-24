import 'package:get/instance_manager.dart';
import 'package:mobile_app/app/data/repository_implements/mock/user_repository_mock.dart';
import 'package:mobile_app/app/data/service_implements/auth_service_impl.dart';
import 'package:mobile_app/app/domain/repository_interfaces/user_repository.dart';
import 'package:mobile_app/app/domain/use_cases/sign_in_use_case.dart';
import 'package:mobile_app/app/domain/use_cases/sign_up_use_case.dart';
import 'entry_screen_controller.dart';

class EntryScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(
      EntryScreenController(
        signInUseCase: SignInUseCase(
          authService: AuthServiceImpl(),
          userRepository: UserRepositoryMock()
        ),
        signUpUseCase: SignUpUseCase(
          authService: AuthServiceImpl(),
        ),
      ),
    );
  }
}
