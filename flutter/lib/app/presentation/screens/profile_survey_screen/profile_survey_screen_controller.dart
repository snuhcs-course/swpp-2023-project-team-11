import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/domain/models/question_bundle.dart';
import 'package:mobile_app/app/domain/models/user.dart';
import 'package:mobile_app/app/domain/use_cases/get_question_bundles_use_case.dart';
import 'package:mobile_app/app/presentation/screens/profile_survey_screen/widgets/complete_dialog.dart';
import 'package:mobile_app/app/presentation/widgets/chat_messages.dart';

class ProfileSurveyScreenController extends GetxController {
  final GetQuestionBundlesUseCase _getQuestionBundlesUseCase;

  final TextEditingController chattingCon = TextEditingController();
  final ScrollController scrollCon = ScrollController();

  void scrollToBottom() {
    scrollCon.animateTo(scrollCon.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250), curve: Curves.linear);
  }

  late final List<QuestionBundle> _questionBundleList;

  int _bundleIndex = -1;

  QuestionBundle? get getCurrentQuestionBundle =>
      _bundleIndex >= _questionBundleList.length ? null : _questionBundleList[_bundleIndex];

  List<Enum> get getCurrentQuestionOptions => getCurrentQuestionBundle?.answerOptions ?? [];
  final chatTextList = <(String, SenderType)>[].obs;

  final openKeywordBoard = false.obs;
  final enableSendButton = false.obs;

  final StreamController<QuestionBundle> _bundleStreamController =
      StreamController<QuestionBundle>();

  Stream<QuestionBundle> get getQuestionBundleStream => _bundleStreamController.stream;

  @override
  void onInit() {
    super.onInit();
    _questionBundleList = _getQuestionBundlesUseCase.call();

    getQuestionBundleStream.listen((questionBundle) {
      final questionAdderStream = getIntervalQuestionStream(questionBundle);
      print(questionBundle.getAnswerType);
      questionAdderStream.listen((questionText) {
        if (questionText != null) {
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
    if (_bundleIndex < _questionBundleList.length) {
      _bundleStreamController.sink.add(getCurrentQuestionBundle!);
    } else {
      //when finish all question bundle
      openCompleteDialog();
    }
  }

  final Map<Type, List<Enum>> answerMap = {};

  Stream<String?> getIntervalQuestionStream(QuestionBundle questionBundle) async* {
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
    answerMap[getCurrentQuestionBundle!.getAnswerType] = [...keywords];
  }

  void onSendButtonTap() async {
    await _answerInChat();
    progressNextQuestionBundle();
    enableSendButton(false);
    openKeywordBoard(false);
  }

  Future<void> _answerInChat() async {
    final answerForPriorIndex = answerMap[getCurrentQuestionBundle!.getAnswerType]!;
    final parsedAnswerText = answerForPriorIndex.join(", ");
    chatTextList.add((parsedAnswerText, SenderType.me));
    scrollToBottom();
  }

  void openCompleteDialog() {
    Get.dialog(
      CompleteDialog(onSubmit: _submit),
      barrierDismissible: false,
    );
  }

  void _submit() {
    // TODO 주목 - hobby, food 등 수집하는 곳
    // 여기에서 데이터 뽑아가기
    // 여기서 signUpUseCase가 사용됨
    print(answerMap[Hobby]);
    print(answerMap[FoodCategory]);
    print(answerMap[MovieGenre]);
    print(answerMap[Location]);

    // 로직 성공한 뒤, Get.offNamed(Routes.MAIN);
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
