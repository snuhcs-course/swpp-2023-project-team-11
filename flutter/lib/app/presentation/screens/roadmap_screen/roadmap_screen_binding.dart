import 'package:get/instance_manager.dart';
import 'package:mobile_app/app/data/repository_implements/roadmap_repository_impl.dart';
import 'package:mobile_app/app/data/service_implements/chatting_service_impl.dart';
import 'package:mobile_app/app/domain/use_cases/fetch_topics_use_case.dart';
import 'package:mobile_app/app/domain/use_cases/send_chat_use_case.dart';
import 'package:mobile_app/app/domain/use_cases/update_intimacy_use_case.dart';
import 'roadmap_screen_controller.dart';

class RoadmapScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(RoadmapScreenController(fetchTopicsUseCase: FetchTopicsUseCase(roadmapRepository: RoadmapRepositoryImpl()), updateIntimacyUseCase: UpdateIntimacyUseCase(roadmapRepository: RoadmapRepositoryImpl()), sendChatUseCase: SendChatUseCase(chattingService: ChattingServiceImpl())));
  }
}