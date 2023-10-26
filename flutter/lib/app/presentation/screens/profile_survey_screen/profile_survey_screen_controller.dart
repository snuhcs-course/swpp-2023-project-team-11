import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/domain/models/question_bundle.dart';
import 'package:mobile_app/app/domain/use_cases/get_question_bundles_use_case.dart';
import 'package:mobile_app/app/presentation/screens/profile_survey_screen/widgets/complete_dialog.dart';
import 'package:mobile_app/app/presentation/widgets/chat_messages.dart';

class ProfileSurveyScreenController extends GetxController {
  final GetQuestionBundlesUseCase _getQuestionBundlesUseCase;

  final TextEditingController chattingCon = TextEditingController();
  final ScrollController scrollCon = ScrollController();

  void scrollToBottom() {
    scrollCon.animateTo(scrollCon.position.maxScrollExtent, duration: const Duration(milliseconds: 250), curve: Curves.linear);
  }

  late final List<QuestionBundle> _questionBundleList;

  int _bundleIndex = -1;

  QuestionBundle? get getCurrentQuestionBundle => _bundleIndex>=_questionBundleList.length?null: _questionBundleList[_bundleIndex];
  List<Enum> get getCurrentQuestionOptions =>  getCurrentQuestionBundle?.answerOptions ?? [];
  final chatTextList = <(String, SenderType)>[].obs;

  final openKeywordBoard = false.obs;
  final enableSendButton = false.obs;

  final StreamController<QuestionBundle> _bundleStreamController = StreamController<QuestionBundle>();
  Stream<QuestionBundle> get getStream => _bundleStreamController.stream;

  late final _answers = List.generate(_questionBundleList.length, (index) => <Enum>[]);

  @override
  void onInit() {
    super.onInit();
    _questionBundleList = _getQuestionBundlesUseCase.call();

    getStream.listen((event) {
      final questionAdderStream = getIntervalQuestionStream(getCurrentQuestionBundle!);
      questionAdderStream.listen((questionText) {
        if (questionText!=null) {
          chatTextList.add((questionText, SenderType.sneki));
        } else {
          openKeywordBoard(true);
        }
      });
    });
    progressNextQuestionBundle();

  }

  void progressNextQuestionBundle() async {
    _bundleIndex++;
    if (_bundleIndex<_questionBundleList.length) {
      _bundleStreamController.sink.add(getCurrentQuestionBundle!);
    } else {
      //when finish all question bundle
      openCompleteDialog();
    }
  }


  Stream<String?> getIntervalQuestionStream(QuestionBundle questionBundle) async * {
    await Future.delayed(const Duration(milliseconds: 50));
    for (final question in questionBundle.questions) {
      yield question;
      await Future.delayed(const Duration(milliseconds: 80));
      scrollToBottom();
      await Future.delayed(const Duration(milliseconds: 230));
    }
    yield null;
  }

  void onKeywordTap(List<Enum> keywords) {
    if (keywords.isEmpty) {
      enableSendButton(false);
    } else {
      enableSendButton(true);
    }
    _answers[_bundleIndex] = keywords;
  }

  void onSendButtonTap() async {
    await answerInChat();
    progressNextQuestionBundle();
    enableSendButton(false);
    openKeywordBoard(false);
  }

  Future<void> answerInChat() async {
    final answerForPriorIndex = _answers[_bundleIndex];
    final parsedAnswerText = answerForPriorIndex.join(", ");
    chatTextList.add((parsedAnswerText, SenderType.me));
    scrollToBottom();
  }

  void openCompleteDialog() {
    Get.dialog(CompleteDialog(onSubmit: _submit));
  }
  void _submit() {
    print(_answers);
  }

  @override
  void onClose() {
    super.onClose();
    scrollCon.dispose();
    chattingCon.dispose();
  }

  ProfileSurveyScreenController({
    required GetQuestionBundlesUseCase getQuestionBundlesUseCase,
  }) : _getQuestionBundlesUseCase = getQuestionBundlesUseCase;
}
