import 'package:get/get.dart';
import 'package:mobile_app/app/domain/use_cases/fetch_users_use_case.dart';
import 'package:mobile_app/routes/named_routes.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../domain/models/user.dart';

class FriendsScreenController extends GetxController with StateMixin<List<User>> {
  final FetchUsersUseCase _fetchUsersUseCase;
  RefreshController refreshController = RefreshController(initialRefresh: false);

  final RxList<User> heartedUser = <User>[].obs;


  FriendsScreenController({
    required FetchUsersUseCase fetchUsersUseCase,
  }) : _fetchUsersUseCase = fetchUsersUseCase;

  void onRefresh() async{
    print("on refresh of user list");
    change(null, status: RxStatus.loading());
    _fetchUsersUseCase.basedOnLogic(whenSuccess: (List<User> users) {
      print("user number 1: ${users[0].name}!");
      change(users, status: RxStatus.success());
    }, whenFail: () => {print("friend fetch 실패")});

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
    change(null, status: RxStatus.loading());
    _fetchUsersUseCase.basedOnLogic(
        whenSuccess: (List<User> users) {
          change(users, status: RxStatus.success());
        },
        whenFail: () => {});
  }

  void onUserContainerTap(User user) {
    Get.toNamed(Routes.Maker(nextRoute: Routes.FRIEND_DETAIL), arguments: user);
  }
}
