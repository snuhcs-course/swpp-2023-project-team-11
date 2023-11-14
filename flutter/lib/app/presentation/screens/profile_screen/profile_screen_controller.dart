import 'package:get/get.dart';
import 'package:mobile_app/app/domain/models/user.dart';
import 'package:mobile_app/app/domain/use_cases/edit_profile_use_case.dart';
import 'package:mobile_app/app/domain/use_cases/sign_out_use_case.dart';
import 'package:mobile_app/app/presentation/global_model_controller/chatting_room_list_controller.dart';
import 'package:mobile_app/app/presentation/global_model_controller/user_controller.dart';
import 'package:mobile_app/core/utils/loading_util.dart';
import 'package:mobile_app/routes/named_routes.dart';

class ProfileScreenController extends GetxController {
  final SignOutUseCase _signOutUseCase;
  final EditProfileUseCase _editProfileUseCase;

  final userController = Get.find<UserController>();

  final languagesEditMode = false.obs;

  Map<Language, String> languageFlagMap = {
    Language.korean: "Korean 🇰🇷",
    Language.english: "English 🇺🇸",
    Language.spanish: "Spanish 🇪🇸",
    Language.chinese: "Chinese 🇨🇳",
    Language.arabic: "Arabic 🇸🇦",
    Language.french: "French 🇫🇷",
    Language.german: "German 🇩🇪",
    Language.japanese: "Japanese 🇯🇵",
    Language.russian: "Russian 🇷🇺",
    Language.portuguese: "Portuguese 🇵🇹",
    Language.italian: "Italian 🇮🇹",
    Language.dutch: "Dutch 🇳🇱",
    Language.swedish: "Swedish 🇸🇪",
    Language.turkish: "Turkish 🇹🇷",
    Language.hebrew: "Hebrew 🇮🇱",
    Language.hindi: "Hindi 🇮🇳",
    Language.thai: "Thai 🇹🇭",
    Language.greek: "Greek 🇬🇷",
    Language.vietnamese: "Vietnamese 🇻🇳",
    Language.finnish: "Finnish 🇫🇮"
  };

  final List<Map<String, Language>> languages1 = [
    {"영어": Language.english},
    {"스페인어": Language.spanish},
    {"중국어": Language.chinese},
    {"아랍어": Language.arabic},
    {"힌디어": Language.hindi},
    {"태국어": Language.thai},
    {"그리스어": Language.greek},
    {"베트남어": Language.vietnamese},
    {"핀란드어": Language.finnish},
    {"히브리어": Language.hebrew},
  ];
  final List<Map<String, Language>> languages2 = [
    {"프랑스어": Language.french},
    {"일본어": Language.japanese},
    {"독일어": Language.german},
    {"러시아어": Language.russian},
    {"포르투갈어": Language.portuguese},
    {"이탈리아어": Language.italian},
    {"네덜란드어": Language.dutch},
    {"스웨덴어": Language.swedish},
    {"터키어": Language.turkish},
  ];
  final Map<String, Language> languageMap = {
    "한국어": Language.korean,
    "영어": Language.english,
    "스페인어": Language.spanish,
    "중국어": Language.chinese,
    "아랍어": Language.arabic,
    "프랑스어": Language.french,
    "독일어": Language.german,
    "일본어": Language.japanese,
    "러시아어": Language.russian,
    "포르투갈어": Language.portuguese,
    "이탈리아어": Language.italian,
    "네덜란드어": Language.dutch,
    "스웨덴어": Language.swedish,
    "터키어": Language.turkish,
    "히브리어": Language.hebrew,
    "힌디어": Language.hindi,
    "태국어": Language.thai,
    "그리스어": Language.greek,
    "베트남어": Language.vietnamese,
    "핀란드어": Language.finnish,
  };

  Map<Hobby, String> hobbyKoreanMap = {
    Hobby.painting: "그림 그리기 🎨",
    Hobby.gardening: "정원 가꾸기 🌿",
    Hobby.hiking: "등산 ⛰️",
    Hobby.reading: "독서 📚",
    Hobby.cooking: "요리 🍳",
    Hobby.photography: "사진 찍기 📷",
    Hobby.dancing: "춤추기 💃",
    Hobby.swimming: "수영 🏊",
    Hobby.cycling: "자전거 타기 🚴",
    Hobby.traveling: "여행 ✈️",
    Hobby.gaming: "게임 🎮",
    Hobby.fishing: "낚시 🎣",
    Hobby.knitting: "뜨개질 🧶",
    Hobby.music: "노래 🎶",
    Hobby.yoga: "요가 🧘",
    Hobby.writing: "글쓰기 ✍️",
    Hobby.shopping: "쇼핑 🛍️",
    Hobby.teamSports: "팀 운동 ⚽",
    Hobby.fitness: "헬스 💪",
    Hobby.movie: "영화 보기 🎥"
  };

  Map<FoodCategory, String> foodKoreanMap = {
    FoodCategory.korean: "한식 🍚",
    FoodCategory.spanish: "스페인 음식 🥘",
    FoodCategory.american: "미국식 음식 🍔",
    FoodCategory.italian: "양식 🍝",
    FoodCategory.thai: "동남아 음식 🍛",
    FoodCategory.chinese: "중식 🍜",
    FoodCategory.japanese: "일식 🍣",
    FoodCategory.indian: "인도 음식 🍛",
    FoodCategory.mexican: "멕시코 음식 🌮",
    FoodCategory.vegan: "채식 🥗",
    FoodCategory.dessert: "디저트류 🍰",
  };

  Map<MovieGenre, String> movieKoreanMap = {
    MovieGenre.action: "액션 💥",
    MovieGenre.adventure: "어드벤처 🌄",
    MovieGenre.animation: "애니 🎬",
    MovieGenre.comedy: "코미디 😄",
    MovieGenre.drama: "드라마 🎭",
    MovieGenre.fantasy: "판타지 🪄",
    MovieGenre.horror: "공포 😱",
    MovieGenre.mystery: "미스터리 🕵️",
    MovieGenre.romance: "로맨스 💌",
    MovieGenre.scienceFiction: "SF 🚀",
    MovieGenre.thriller: "스릴러 💀",
    MovieGenre.western: "서부극 🌵",
  };

  Map<Location, String> locationKoreanMap = {
    Location.humanity: "인문대",
    Location.naturalScience: "자연대",
    Location.dormitory: "기숙사",
    Location.socialScience: "사회과학대",
    Location.humanEcology: "생활대",
    Location.agriculture: "농대",
    Location.highEngineering: "윗공대",
    Location.lowEngineering: "아랫공대",
    Location.business: "경영대",
    Location.jahayeon: "자하연",
    Location.studentUnion: "학생회관",
    Location.seolYeep: "설입",
    Location.nockDoo: "녹두",
    Location.bongcheon: "봉천",
  };

  void onLogOutButtonTap() async {
    LoadingUtil.withLoadingOverlay(asyncFunction: () async {
      await _signOutUseCase.call(onSuccess: onLogOutSuccess);
    });
  }

  void onProfileEditActivateTap() async {
    print("editing profile mode activated");
    languagesEditMode.value = false;
  }

  // functions for editing languages category
  void onLanguagesEditActivateTap() {
    languagesEditMode.value = true;
  }

  void onLanguagesEditCompleteTap() async {
    // need to call update user profile at the repo at this point
    // await _editProfileUseCase.call({"lang": toAdd.value}, {"lang": toRemove.value}, () {print("profile edit success");}, () {print("profile edit fail");});

    User user = userController.user;
    user.getLanguages.addAll(toAdd.value);
    for (Language l in toRemove.value) user.getLanguages.remove(l);

    toAdd.value.clear();
    toRemove.value.clear();

    print("language edit complete");
    languagesEditMode.value = false;
  }

  final RxList<Language> toAdd = <Language>[].obs;
  final RxList<Language> toRemove = <Language>[].obs;

  void languagesEditManager(Language languageOfInterest) {
    if (toAdd.value.contains(languageOfInterest))
      toAdd.value.remove(languageOfInterest);
    else if (toRemove.value.contains(languageOfInterest))
      toRemove.value.remove(languageOfInterest);
    else if (userController.userLanguages.contains(languageOfInterest))
      toRemove.value.add(languageOfInterest);
    else
      toAdd.value.add(languageOfInterest);

    toAdd.refresh();
    toRemove.refresh();

    print(userController.userLanguages);
    print("current result: ${toAdd.value} and ${toRemove.value}");
  }

  bool languageStatusCheck(Language languageOfInterest) {
    if (toAdd.value.contains(languageOfInterest) ||
        (userController.userLanguages.contains(languageOfInterest) &&
            !toRemove.value.contains(languageOfInterest))) {
      return true;
    }
    return false;
  }

  // functions for editing hobbies category

  void onLogOutSuccess() {
    Get.find<ChattingRoomListController>()
        .deleteAllValidChattingRoomDependency();
    Get.offAllNamed(Routes.ENTRY);
  }

  ProfileScreenController(
      {required SignOutUseCase signOutUseCase,
      required EditProfileUseCase editProfileUseCase})
      : _signOutUseCase = signOutUseCase,
        _editProfileUseCase = editProfileUseCase;
}
