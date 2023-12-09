import 'package:get/get.dart';
import 'package:mobile_app/app/domain/models/question_bundle.dart';
import 'package:mobile_app/app/domain/models/user.dart';

final questionBundles = <QuestionBundle>[
  QuestionBundle<Hobby>(
    questions: [
      "SNEK에 온 걸 환영해요!".tr,
      "우선 몇가지를 물어보려 해요!\n 금방 끝날테니 안심하세요 :)".tr,
      "첫번째, 좋아하는 취미 몇 가지를 골라주세요.".tr
    ],
    answerOptions: Hobby.values,
  ),
  QuestionBundle<FoodCategory>(
    questions: [
      "감사해요!".tr,
      "두번째로, 좋아하는 음식 종류를 몇 개 골라주세요.".tr,
    ],
    answerOptions: FoodCategory.values,
  ),
  QuestionBundle<MovieGenre>(
    questions: [
      "이제 거의 다 왔어요!".tr,
      "어떤 영화 장르를 좋아하시나요? 몇 개 골라주세요!".tr
    ],
    answerOptions: MovieGenre.values,
  ),
  QuestionBundle<Location>(
    questions: [
      "마지막이에요!".tr,
      "주로 학교에서 출몰하는 장소를 골라주세요".tr,
    ],
    answerOptions: Location.values,
  ),
];
