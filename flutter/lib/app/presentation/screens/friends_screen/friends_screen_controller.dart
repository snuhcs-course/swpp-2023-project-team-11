import 'package:get/get.dart';
import 'package:mobile_app/app/domain/use_cases/fetch_users_use_case.dart';

import '../../../domain/models/user.dart';

class FriendsScreenController extends GetxController {
  final FetchUsersUseCase _fetchUsersUseCase;
  final users = <User>[].obs;

  FriendsScreenController({
    required FetchUsersUseCase fetchUsersUseCase,
  }) : _fetchUsersUseCase = fetchUsersUseCase;

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    _fetchUsersUseCase.basedOnLogic(
        whenSuccess: (List<User> users) {
          this.users(users);
        },
        whenFail: () => {});
  }
}
