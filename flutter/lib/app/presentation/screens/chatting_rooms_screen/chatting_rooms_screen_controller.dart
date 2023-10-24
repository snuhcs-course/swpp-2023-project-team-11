import 'package:get/get.dart';
import 'package:mobile_app/app/domain/models/chatting_room.dart';
import 'package:mobile_app/app/domain/use_cases/fetch_chatrooms_use_case.dart';
import 'package:mobile_app/routes/named_routes.dart';

class ChattingRoomsScreenController extends GetxController{

  final FetchChatroomsUseCase _fetchChatroomsUseCase;
  final chatrooms = <ChattingRoom>[].obs;
  final Rxn<bool> newChatRequestExists = Rxn(null); // 새로운 채팅 요청 여부에 따라 업데이트 돼어야함

  ChattingRoomsScreenController({
    required FetchChatroomsUseCase fetchChatroomsUseCase,
  }) : _fetchChatroomsUseCase = fetchChatroomsUseCase;

  void onNewChatRequestTap() {
    Get.toNamed(Routes.Maker(nextRoute: Routes.CHAT_REQUESTS));
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    this.newChatRequestExists.value = true;
  }

  @override
  void onReady() {
    super.onReady();
    _fetchChatroomsUseCase(
        whenSuccess: (List<ChattingRoom> chatrooms) {
          this.chatrooms(chatrooms);
        },
        whenFail: () => {});
  }

}