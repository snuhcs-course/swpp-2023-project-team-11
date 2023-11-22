import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/domain/models/user.dart';
import 'package:mobile_app/app/domain/use_cases/request_chatting_use_case.dart';
import 'package:mobile_app/app/presentation/global_model_controller/chatting_room_list_controller.dart';
import 'package:mobile_app/app/presentation/screens/friend_detail_screen/widgets/chatting_wait_bottom_sheet.dart';
import 'package:mobile_app/core/themes/color_theme.dart';
import 'package:mobile_app/core/utils/loading_util.dart';

class FriendDetailScreenController extends GetxController {
  final RequestChattingUseCase _requestChattingUseCase;
  User user = Get.arguments as User;

  final ChattingRoomListController chattingRoomListController = Get.find<ChattingRoomListController>();

  Map <Language, String> languageFlagMap = {
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

  Map <Hobby, String> hobbyKoreanMap = {
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

  void onRequestButtonTap() {
    LoadingUtil.withLoadingOverlay(asyncFunction: () async {
      await _requestChattingUseCase.call(
        counterPartEmail: user.email,
        whenSuccess: _whenRequestSuccess,
        whenFail: () {
          Fluttertoast.showToast(
            msg: "해당 유저와는 이미 채팅이 진행되고 있어요".tr,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: MyColor.purple,
              textColor: Colors.white,
              fontSize: 15.0
          );
          print("채팅방 생성 실패...");
        },
      );

    });
  }

  void _whenRequestSuccess() {
    chattingRoomListController.reloadRooms();
    Get.bottomSheet(
      ChattingWaitBottomSheet(
        onConfirmButtonTap: () {
          Get.until((route) => route.settings.name == "/main");
          Get.back();
        },
      ),
    );
  }

  FriendDetailScreenController({
    required RequestChattingUseCase requestChattingUseCase,
  }) : _requestChattingUseCase = requestChattingUseCase;
}
