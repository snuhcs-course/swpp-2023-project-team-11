import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/domain/models/question_bundle.dart';
import 'package:mobile_app/app/domain/models/user.dart';
import 'package:mobile_app/app/domain/use_cases/get_question_bundles_use_case.dart';
import 'package:mobile_app/app/domain/use_cases/sign_up_use_case.dart';
import 'package:mobile_app/app/presentation/screens/additional_profile_info_screen/additional_profile_info_screen_controller.dart';
import 'package:mobile_app/app/presentation/screens/country_screen/country_screen_controller.dart';
import 'package:mobile_app/app/presentation/screens/email_screen/email_screen_controller.dart';
import 'package:mobile_app/app/presentation/screens/make_profile_screen/make_profile_screen_controller.dart';
import 'package:mobile_app/app/presentation/screens/password_screen/password_screen_controller.dart';
import 'package:mobile_app/app/presentation/screens/profile_survey_screen/widgets/complete_dialog.dart';
import 'package:mobile_app/app/presentation/widgets/chat_messages.dart';
import 'package:mobile_app/core/utils/loading_util.dart';
import 'package:mobile_app/routes/named_routes.dart';

class ProfileSurveyScreenController extends GetxController {
  final GetQuestionBundlesUseCase _getQuestionBundlesUseCase;
  final SignUpUseCase _signUpUseCase;

  final TextEditingController chattingCon = TextEditingController();
  final ScrollController scrollCon = ScrollController();

  void scrollToBottom() {
    scrollCon.animateTo(scrollCon.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250), curve: Curves.linear);
  }

  late final List<QuestionBundle> _questionBundleList;

  int _bundleIndex = -1;

  QuestionBundle? get getCurrentQuestionBundle =>
      _bundleIndex >= _questionBundleList.length
          ? null
          : _questionBundleList[_bundleIndex];

  List<Enum> get getCurrentQuestionOptions =>
      getCurrentQuestionBundle?.answerOptions ?? [];
  final chatTextList = <(String, SenderType)>[].obs;

  final openKeywordBoard = false.obs;
  final enableSendButton = false.obs;

  final StreamController<QuestionBundle> _bundleStreamController =
      StreamController<QuestionBundle>();

  Stream<QuestionBundle> get getQuestionBundleStream =>
      _bundleStreamController.stream;

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

  Stream<String?> getIntervalQuestionStream(
      QuestionBundle questionBundle) async* {
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
    final answerForPriorIndex =
        answerMap[getCurrentQuestionBundle!.getAnswerType]!;
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

  void toMainScreen(User user) {
    Get.offAllNamed(Routes.MAIN, arguments: user);
  }

  void _submit() async {
    final additionalInfo = Get.find<AdditionalProfileInfoScreenController>();
    final profileInfo = Get.find<MakeProfileScreenController>();
    final countryInfo = Get.find<CountryScreenController>();
    final String password = Get.find<PasswordScreenController>().password;
    final emailInfo = Get.find<EmailScreenController>();
    Profile profile = Profile(
      birth: additionalInfo.birth,
      sex: additionalInfo.sex,
      major: additionalInfo.department,
      admissionYear: additionalInfo.admissionYear,
      aboutMe: profileInfo.aboutMe,
      mbti: additionalInfo.mbti,
      hobbies: answerMap[Hobby]!.cast<Hobby>(),
      foodCategories: answerMap[FoodCategory]!.cast<FoodCategory>(),
      movieGenres: answerMap[MovieGenre]!.cast<MovieGenre>(),
      locations: answerMap[Location]!.cast<Location>(),
      nationCode: countryInfo.countryCode,
    );

    User user = countryInfo.isKorean
        ? KoreanUser(
            name: profileInfo.nickname,
            mainLanguage: Language.korean,
            type: UserType.korean,
            email: emailInfo.email,
            wantedLanguages: profileInfo.selectedLanguages.value,
            profile: profile)
        : ForeignUser(
            name: profileInfo.nickname,
            type: UserType.foreign,
            email: emailInfo.email,
            mainLanguage: profileInfo.mainLanguage,
            subLanguages: profileInfo.selectedLanguages.value,
            profile: profile);

    [user.name, user.email, user.profile.toJson(), user.type].forEach(print);

    LoadingUtil.withLoadingOverlay(asyncFunction: () async {
      await _signUpUseCase(
          email: emailInfo.email,
          emailToken: emailInfo.emailToken,
          password: password,
          user: user,
          onFail: () {
            print("Fail on creating user");
          },
          onSuccess: (user) {
            toMainScreen(user);
          });
    });

    // 로직 성공한 뒤, Get.offNamed(Routes.MAIN);
  }

  @override
  void onClose() {
    super.onClose();
    scrollCon.dispose();
    chattingCon.dispose();
  }

  ProfileSurveyScreenController(
      {required GetQuestionBundlesUseCase getQuestionBundlesUseCase,
      required SignUpUseCase signUpUseCase})
      : _getQuestionBundlesUseCase = getQuestionBundlesUseCase,
        _signUpUseCase = signUpUseCase;
}
