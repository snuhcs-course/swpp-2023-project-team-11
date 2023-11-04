import 'package:get/get.dart';
import 'package:mobile_app/app/domain/models/user.dart';
import 'package:mobile_app/app/presentation/screens/friend_detail_screen/widgets/chatting_wait_bottom_sheet.dart';
import 'package:mobile_app/core/utils/loading_util.dart';

class FriendDetailScreenController extends GetxController {
  User user = Get.arguments as User;

  void onRequestButtonTap() {
    LoadingUtil.withLoadingOverlay(asyncFunction: () async {
      await Future.delayed(const Duration(milliseconds: 50));
      Get.bottomSheet(
        ChattingWaitBottomSheet(
          onConfirmButtonTap: () {
            Get.until((route) => route.settings.name == "/main");
          },
        ),
      );
    });
  }
}
