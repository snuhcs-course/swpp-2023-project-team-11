import 'package:get/get.dart';
import 'package:mobile_app/app/domain/models/user.dart';
import 'package:mobile_app/app/domain/use_cases/request_chatting_use_case.dart';
import 'package:mobile_app/app/presentation/screens/friend_detail_screen/widgets/chatting_wait_bottom_sheet.dart';
import 'package:mobile_app/core/utils/loading_util.dart';
import 'package:mobile_app/routes/named_routes.dart';

class FriendDetailScreenController extends GetxController {
  final RequestChattingUseCase _requestChattingUseCase;
  User user = Get.arguments as User;

  void onRequestButtonTap() {
    LoadingUtil.withLoadingOverlay(asyncFunction: () async {
      _requestChattingUseCase.call(
        counterPartEmail: user.email,
        whenSuccess: _whenRequestSuccess,
        whenFail: () {
          print("채팅방 생성 실패...");
        },
      );

    });
  }

  void _whenRequestSuccess() {
    Get.bottomSheet(
      ChattingWaitBottomSheet(
        onConfirmButtonTap: () {
          Get.until((route) => route.settings.name == "/main");
          Get.toNamed(Routes.Maker(nextRoute: Routes.CHAT_REQUESTS));
        },
      ),
    );
  }

  FriendDetailScreenController({
    required RequestChattingUseCase requestChattingUseCase,
  }) : _requestChattingUseCase = requestChattingUseCase;
}
