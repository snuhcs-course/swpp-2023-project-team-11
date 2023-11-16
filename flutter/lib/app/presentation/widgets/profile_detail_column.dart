

import 'package:flutter/material.dart';
import 'package:mobile_app/app/domain/models/user.dart';
import 'package:mobile_app/core/themes/color_theme.dart';

class ProfileDetailColumn extends StatelessWidget{

  final User user;

  final Map <Language, String> languageFlagMap = {
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

  final Map <Hobby, String> hobbyKoreanMap = {
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

  final Map<FoodCategory, String> foodKoreanMap = {
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

  final Map<MovieGenre, String> movieKoreanMap = {
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

  final Map<Location, String> locationKoreanMap = {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAboutMeContainer(),
        const SizedBox(height: 24),
        if (user.getNationCode != 82)
          _buildMainLanguageContainer(),
        Text(
          (user.getNationCode == 82)
              ? "희망 교환 언어"
              : "주 언어 외 구사 가능 언어",
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: MyColor.textBaseColor.withOpacity(0.8)),
        ),
        const SizedBox(height: 8),
        _buildLanguageList(),
        const SizedBox(height: 24),
        Text(
          "좋아하는 것들",
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: MyColor.textBaseColor.withOpacity(0.8)),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black.withOpacity(0.1))),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("# 취미",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: MyColor.textBaseColor.withOpacity(0.8))),
                const SizedBox(height: 6),
                _buildHobbyContainer(),
                const SizedBox(height: 6),
                Divider(
                    color: Colors.black.withOpacity(0.1), thickness: 1),
                const SizedBox(height: 6),
                Text("# 음식",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: MyColor.textBaseColor.withOpacity(0.8))),
                const SizedBox(height: 6),
                _buildFoodContainer(),
                const SizedBox(height: 6),
                Divider(
                    color: Colors.black.withOpacity(0.1), thickness: 1),
                const SizedBox(height: 6),
                Text("# 영화 장르",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: MyColor.textBaseColor.withOpacity(0.8))),
                const SizedBox(height: 6),
                _buildMovieContainer(),
                const SizedBox(height: 6),
                Divider(
                    color: Colors.black.withOpacity(0.1), thickness: 1),
                const SizedBox(height: 6),
                Text("# 주로 출몰하는 장소",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: MyColor.textBaseColor.withOpacity(0.8))),
                const SizedBox(height: 6),
                _buildLocationContainer()
              ],
            ),
          ),
        )
      ],
    );
  }

  Container _buildAboutMeContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
          border: Border(
              left: BorderSide(width: 3, color: MyColor.purple))),
      child: Column(
        children: [
          Text(
            user.profile.aboutMe,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }

  Container _buildMainLanguageContainer() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "사용하는 주언어",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: MyColor.textBaseColor.withOpacity(0.8)),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border:
                Border.all(color: Colors.black.withOpacity(0.1), width: 1)),
            padding: const EdgeInsets.all(6),
            margin: const EdgeInsets.all(4),
            child: Text(
              languageFlagMap[user.getMainLanguage]!,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: MyColor.textBaseColor,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Container _buildHobbyContainer() {
    return Container(
        child: Wrap(
          children: [
            for (Hobby hobby in user.profile.hobbies)
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xfff8f1fb)),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                margin: const EdgeInsets.all(4),
                child: Text(
                  hobbyKoreanMap[hobby]!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: MyColor.textBaseColor,
                  ),
                ),
              ),
          ],
        ));
  }

  Container _buildFoodContainer() {
    return Container(
        child: Wrap(
          children: [
            for (FoodCategory foodCategory
            in user.profile.foodCategories)
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xfff8f1fb)),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                margin: const EdgeInsets.all(4),
                child: Text(
                  foodKoreanMap[foodCategory]!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: MyColor.textBaseColor,
                  ),
                ),
              ),
          ],
        ));
  }

  Container _buildMovieContainer() {
    return Container(
        child: Wrap(
          children: [
            for (MovieGenre moviegenre in user.profile.movieGenres)
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xfff8f1fb)),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                margin: const EdgeInsets.all(4),
                child: Text(
                  movieKoreanMap[moviegenre]!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: MyColor.textBaseColor,
                  ),
                ),
              ),
          ],
        ));
  }

  Container _buildLocationContainer() {
    return Container(
        child: Wrap(
          children: [
            for (Location location in user.profile.locations)
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xfff8f1fb)),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                margin: const EdgeInsets.all(4),
                child: Text(
                  locationKoreanMap[location]!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: MyColor.textBaseColor,
                  ),
                ),
              ),
          ],
        ));
  }

  Wrap _buildLanguageList() {
    return Wrap(
      children: [
        for (Language language in user.getLanguages) if(language != user.getMainLanguage)
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border:
                Border.all(color: Colors.black.withOpacity(0.1), width: 1)),
            padding: const EdgeInsets.all(6),
            margin: const EdgeInsets.all(4),
            child: Text(
              languageFlagMap[language]!,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: MyColor.textBaseColor,
              ),
            ),
          ),
      ],
    );
  }

  ProfileDetailColumn({super.key, 
    required this.user,
  });
}