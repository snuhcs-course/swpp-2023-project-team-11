import 'package:get/instance_manager.dart';
import 'package:mobile_app/app/domain/use_cases/get_question_bundles_use_case.dart';
import 'profile_survey_screen_controller.dart';

class ProfileSurveyScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(
      ProfileSurveyScreenController(
        getQuestionBundlesUseCase: GetQuestionBundlesUseCase(),
      ),
    );
  }
}
