import 'package:get/instance_manager.dart';
import 'package:mobile_app/app/data/repository_implements/user_repository_impl.dart';
import 'package:mobile_app/app/domain/use_cases/fetch_users_use_case.dart';
import 'friends_screen_controller.dart';

class FriendsScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(FriendsScreenController(
      fetchUsersUseCase: FetchUsersUseCase(
        userRepository: UserRepositoryImpl()
      )
    ));
  }
}