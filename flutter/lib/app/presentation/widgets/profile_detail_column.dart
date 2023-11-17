

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/domain/models/user.dart';
import 'package:mobile_app/core/themes/color_theme.dart';

class ProfileDetailColumn extends StatelessWidget{

  final User user;

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
              ? "희망 교환 언어".tr
              : "주 언어 외 구사 가능 언어".tr,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: MyColor.textBaseColor.withOpacity(0.8)),
        ),
        const SizedBox(height: 8),
        _buildLanguageList(),
        const SizedBox(height: 24),
        Text(
          "좋아하는 것들".tr,
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
                Text("# 취미".tr,
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
                Text("# 음식".tr,
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
                Text("# 영화 장르".tr,
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
                Text("# 주로 출몰하는 장소".tr,
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
            "사용하는 주언어".tr,
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
              user.getMainLanguage.toString(),
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
                  hobby.toString(),
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
                  foodCategory.toString(),
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
                  moviegenre.toString(),
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
                  location.toString(),
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
              language.toString(),
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