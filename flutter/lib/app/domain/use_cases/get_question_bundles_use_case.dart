import 'package:mobile_app/app/domain/models/question_bundle.dart';
import 'package:mobile_app/core/constants/question_bundles.dart';

class GetQuestionBundlesUseCase {

  List<QuestionBundle> call() {
    return questionBundles;
  }
}