import 'package:get/get.dart';
import 'package:mobile_app/app/domain/use_cases/fetch_users_use_case.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:math';

import '../../../domain/models/user.dart';

class FriendsScreenController extends GetxController {
  final FetchUsersUseCase _fetchUsersUseCase;
  final users = <User>[].obs;
  RefreshController refreshController = RefreshController(initialRefresh: false);


  Random random = Random();


  FriendsScreenController({
    required FetchUsersUseCase fetchUsersUseCase,
  }) : _fetchUsersUseCase = fetchUsersUseCase;

  void onRefresh() async{

    _fetchUsersUseCase.basedOnLogic(whenSuccess: (List<User> users) {
      this.users(users);
    }, whenFail: () => {});

    // if failed,use refreshFailed()
    refreshController.refreshCompleted();
  }

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
