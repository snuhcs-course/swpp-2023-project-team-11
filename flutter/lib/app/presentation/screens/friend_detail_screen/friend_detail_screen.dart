import 'dart:math';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/app/domain/models/user.dart';
import 'package:mobile_app/app/presentation/widgets/app_bars.dart';
import 'package:mobile_app/app/presentation/widgets/buttons.dart';
import 'package:mobile_app/core/themes/color_theme.dart';

// ignore: unused_import
import 'friend_detail_screen_controller.dart';

class FriendDetailScreen extends GetView<FriendDetailScreenController> {
  const FriendDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: FriendDetailAppBar(
        profileImage: AssetImage(
          'assets/images/snek_profile_img_${Random().nextInt(5) + 1}.webp',
        ),
        userName: "${controller.user.name}",
        userEmail: "${controller.user.email}",
      ),
      // TODO 화면 그리기
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAboutMeContainer(),
              const SizedBox(height: 24),
              if (controller.user.getNationCode != 82)
                _buildMainLanguageContainer(),
              Text(
                (controller.user.getNationCode == 82)
                    ? "희망 교환 언어"
                    : "주 언어 외 구사 가능 언어",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: MyColor.textBaseColor.withOpacity(0.8)),
              ),
              const SizedBox(height: 8),
              _buildLanguageList(),
              SizedBox(height: 24),
              Text(
                "좋아하는 것들",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: MyColor.textBaseColor.withOpacity(0.8)),
              ),
              SizedBox(height: 8),
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
                      SizedBox(height: 6),
                      _buildHobbyContainer(),
                      SizedBox(height: 6),
                      Divider(
                          color: Colors.black.withOpacity(0.1), thickness: 1),
                      SizedBox(height: 6),
                      Text("# 음식",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: MyColor.textBaseColor.withOpacity(0.8))),
                      SizedBox(height: 6),
                      _buildFoodContainer(),
                      SizedBox(height: 6),
                      Divider(
                          color: Colors.black.withOpacity(0.1), thickness: 1),
                      SizedBox(height: 6),
                      Text("# 영화 장르",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: MyColor.textBaseColor.withOpacity(0.8))),
                      SizedBox(height: 6),
                      _buildMovieContainer(),
                      SizedBox(height: 6),
                      Divider(
                          color: Colors.black.withOpacity(0.1), thickness: 1),
                      SizedBox(height: 6),
                      Text("# 주로 출몰하는 장소",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: MyColor.textBaseColor.withOpacity(0.8))),
                      SizedBox(height: 6),
                      _buildLocationContainer()
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(20)
            .copyWith(bottom: 20 + MediaQuery.of(context).padding.bottom / 2),
        child: MainButton(
          mainButtonType: MainButtonType.key,
          onPressed: controller.onRequestButtonTap,
          text: "채팅 신청",
        ),
      ),
    );
  }

  Container _buildAboutMeContainer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
          border: Border(
              left: BorderSide(width: 3, color: MyColor.purple))),
      child: Column(
        children: [
          Text(
            controller.user.profile.aboutMe,
            style: TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }

  Container _buildMainLanguageContainer() {
    return Container(
      child: Column(
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
              controller.languageFlagMap[controller.user.getMainLanguage]!,
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
            for (Hobby hobby in controller.user.profile.hobbies)
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xfff8f1fb)),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                margin: const EdgeInsets.all(4),
                child: Text(
                  controller.hobbyKoreanMap[hobby]!,
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
            in controller.user.profile.foodCategories)
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xfff8f1fb)),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                margin: const EdgeInsets.all(4),
                child: Text(
                  controller.foodKoreanMap[foodCategory]!,
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
            for (MovieGenre moviegenre in controller.user.profile.movieGenres)
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xfff8f1fb)),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                margin: const EdgeInsets.all(4),
                child: Text(
                  controller.movieKoreanMap[moviegenre]!,
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
            for (Location location in controller.user.profile.locations)
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xfff8f1fb)),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                margin: const EdgeInsets.all(4),
                child: Text(
                  controller.locationKoreanMap[location]!,
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
        for (Language language in controller.user.getLanguages)
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border:
                Border.all(color: Colors.black.withOpacity(0.1), width: 1)),
            padding: const EdgeInsets.all(6),
            margin: const EdgeInsets.all(4),
            child: Text(
              controller.languageFlagMap[language]!,
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
}
