import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/app/domain/models/user.dart';
import 'package:mobile_app/app/presentation/widgets/app_bars.dart';
import 'package:mobile_app/app/presentation/widgets/buttons.dart';
import 'package:mobile_app/app/presentation/widgets/profile_pic_provider.dart';
import 'package:mobile_app/core/themes/color_theme.dart';

// ignore: unused_import
import 'profile_screen_controller.dart';

class ProfileScreen extends GetView<ProfileScreenController> {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: FriendDetailAppBar(
        profileImage: ProfilePic.call(controller.userController.userEmail),
        userName: controller.userController.userName,
        userEmail: controller.userController.userEmail,
        isMyProfile: true,
        actionFunction: controller.onProfileEditActivateTap,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16, left: 24, right: 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAboutMeContainer(),
              const SizedBox(height: 24),
              if (controller.userController.userProfile.nationCode != 82)
                _buildMainLanguageContainer(),
              Row(
                children: [
                  Text(
                    (controller.userController.userProfile.nationCode == 82)
                        ? "희망 교환 언어".tr
                        : "주 언어 외 구사 가능 언어".tr,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: MyColor.textBaseColor.withOpacity(0.8)),
                  ),
                  Obx(() {
                    return _buildEditCompleteButton();
                  })
                ],
              ),
              const SizedBox(height: 8),
              Obx(() {
                return _buildLanguageList();
              }),
              const SizedBox(height: 24),
              Text(
                "좋아하는 것들".tr,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: MyColor.textBaseColor.withOpacity(0.8)),
              ),
              const SizedBox(height: 8),
              _buildLikeContainer(),
              const SizedBox(height: 24),
              MainButton(
                  mainButtonType: MainButtonType.key,
                  text: "로그아웃".tr,
                  onPressed: controller.onLogOutButtonTap),
              const SizedBox(height: 100)
            ],
          ),
        ),
      ),
    );
  }

  Container _buildEditCompleteButton() {
    return Container(
                      height: 20,
                      alignment: Alignment.topCenter,
                      child: (controller.languagesEditMode.value)
                          ? IconButton(
                        onPressed: controller.onLanguagesEditCompleteTap,
                        icon: const Icon(Icons.done_outline_outlined,
                            size: 18, color: MyColor.orange_1),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      )
                          : IconButton(
                        onPressed: controller.onLanguagesEditActivateTap,
                        icon: const Icon(Icons.edit,
                            size: 18, color: MyColor.orange_1),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ));
  }

  Container _buildLikeContainer() {
    return Container(
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
            Divider(color: Colors.black.withOpacity(0.1), thickness: 1),
            const SizedBox(height: 6),
            Text("# 음식".tr,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: MyColor.textBaseColor.withOpacity(0.8))),
            const SizedBox(height: 6),
            _buildFoodContainer(),
            const SizedBox(height: 6),
            Divider(color: Colors.black.withOpacity(0.1), thickness: 1),
            const SizedBox(height: 6),
            Text("# 영화 장르".tr,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: MyColor.textBaseColor.withOpacity(0.8))),
            const SizedBox(height: 6),
            _buildMovieContainer(),
            const SizedBox(height: 6),
            Divider(color: Colors.black.withOpacity(0.1), thickness: 1),
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
    );
  }

  Container _buildAboutMeContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
          border: Border(left: BorderSide(width: 3, color: MyColor.purple))),
      child: Column(
        children: [
          Text(
            controller.userController.userAboutMe,
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
              controller.userController.userMainLanguage.toString(),
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
            for (Hobby hobby in controller.userController.userProfile.hobbies)
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xfff8f1fb)),
                padding: const EdgeInsets.symmetric(
                    vertical: 8, horizontal: 10),
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
            in controller.userController.userProfile.foodCategories)
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xfff8f1fb)),
                padding: const EdgeInsets.symmetric(
                    vertical: 8, horizontal: 10),
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
            for (MovieGenre moviegenre
            in controller.userController.userProfile.movieGenres)
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xfff8f1fb)),
                padding: const EdgeInsets.symmetric(
                    vertical: 8, horizontal: 10),
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
            for (Location location
            in controller.userController.userProfile.locations)
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xfff8f1fb)),
                padding: const EdgeInsets.symmetric(
                    vertical: 8, horizontal: 10),
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

  Widget _buildLanguageList() {
    if (controller.languagesEditMode.value) {
      return _buildLanguagesEditList();
    } else {
      return Wrap(
        children: [
          for (Language language in controller.userController.userLanguages)
            if (language != controller.userController.userMainLanguage)
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Colors.black.withOpacity(0.1), width: 1)),
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
  }

  Widget _buildLanguagesEditList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              for(var language in controller.languagesList1) if (language != controller.userController.userMainLanguage) Align(
                child: GestureDetector(
                  onTap: () {
                    controller.languagesEditManager(language);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: controller.languageStatusCheck(language) ? MyColor
                            .orange_1 : Colors.black.withOpacity(0.1),
                            width: 1)),
                    padding: const EdgeInsets.all(6),
                    margin: const EdgeInsets.all(4),
                    child: Text(
                      language.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: controller.languageStatusCheck(language)
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: controller.languageStatusCheck(language) ? MyColor
                            .orange_1 : MyColor
                            .textBaseColor,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          Row(
            children: [
              for(var language in controller.languagesList2) if (language != controller.userController.userMainLanguage) Align(
                child: GestureDetector(
                  onTap: () {
                    controller.languagesEditManager(language);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: controller.languageStatusCheck(language) ? MyColor
                            .orange_1 : Colors.black.withOpacity(0.1),
                            width: 1)),
                    padding: const EdgeInsets.all(6),
                    margin: const EdgeInsets.all(4),
                    child: Text(
                      language.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: controller.languageStatusCheck(language)
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: controller.languageStatusCheck(language) ? MyColor
                            .orange_1 : MyColor
                            .textBaseColor,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),

        ],
      ),
    );
  }
}

// GetPage(
//   name: ,
//   page: () => const ProfileScreen(),
//   binding: ProfileScreenBinding(),
// )
