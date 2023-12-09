import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/domain/models/user.dart';
import 'package:mobile_app/app/domain/use_cases/edit_profile_use_case.dart';
import 'package:mobile_app/app/domain/use_cases/sign_out_use_case.dart';
import 'package:mobile_app/app/presentation/global_model_controller/chatting_room_list_controller.dart';
import 'package:mobile_app/app/presentation/global_model_controller/user_controller.dart';
import 'package:mobile_app/core/themes/color_theme.dart';
import 'package:mobile_app/core/utils/loading_util.dart';
import 'package:mobile_app/routes/named_routes.dart';

class ProfileScreenController extends GetxController {
  final SignOutUseCase _signOutUseCase;
  final EditProfileUseCase _editProfileUseCase;

  final userController = Get.find<UserController>();

  final languagesEditMode = false.obs;
  final likeTagsEditMode = false.obs;
  final hobbyAddMode = false.obs;
  final foodCategoryAddMode = false.obs;
  final movieGenreAddMode = false.obs;
  final locationAddMode = false.obs;

  final List<Language> languagesList1 = [
    Language.english,
    Language.spanish,
    Language.chinese,
    Language.arabic,
    Language.hindi,
    Language.thai,
    Language.greek,
    Language.vietnamese,
    Language.finnish,
    Language.hebrew,
  ];
  final List<Language> languagesList2 = [Language.french,
    Language.japanese, Language.german,
    Language.russian,
    Language.portuguese,
    Language.italian,
    Language.dutch,
    Language.swedish,
    Language.turkish,
  ];

  final RxList<Language> languagesToAdd = <Language>[].obs;
  final RxList<Language> languagesToRemove = <Language>[].obs;

  final RxList<Hobby> hobbyToAdd = <Hobby>[].obs;
  final RxList<Hobby> hobbyToRemove = <Hobby>[].obs;
  final RxList<Hobby> currentHobby = <Hobby>[].obs;

  final RxList<FoodCategory> foodCategoryToAdd = <FoodCategory>[].obs;
  final RxList<FoodCategory> foodCategoryToRemove = <FoodCategory>[].obs;
  final RxList<FoodCategory> currentFoodCategory = <FoodCategory>[].obs;

  final RxList<MovieGenre> movieGenreToAdd = <MovieGenre>[].obs;
  final RxList<MovieGenre> movieGenreToRemove = <MovieGenre>[].obs;
  final RxList<MovieGenre> currentMovieGenre = <MovieGenre>[].obs;

  final RxList<Location> locationToAdd = <Location>[].obs;
  final RxList<Location> locationToRemove = <Location>[].obs;
  final RxList<Location> currentLocation = <Location>[].obs;

  void onLogOutButtonTap() async {
    LoadingUtil.withLoadingOverlay(asyncFunction: () async {
      await _signOutUseCase.call(onSuccess: onLogOutSuccess);
    });
  }

  // functions for editing languages category
  void onLanguagesEditActivateTap() {
    languagesEditMode.value = true;
  }

  void onLanguagesEditCompleteTap() async {
    // need to call update user profile at the repo at this point
    // print(toAdd.value);
    List<String> toAddString = [];
    languagesToAdd.forEach((element) {toAddString.add(element.enName.toLowerCase());});
    List<String> toRemoveString = [];
    languagesToRemove.forEach((element) {toRemoveString.add(element.enName.toLowerCase());});

    print("add: ${toAddString}, remove: ${toRemoveString}");

    await _editProfileUseCase.call({"lang": toAddString}, {"lang": toRemoveString}, () {
      print("profile edit success");
      User user = userController.user;
      user.getLanguages.addAll(languagesToAdd);
      for (Language l in languagesToRemove) {
        user.getLanguages.remove(l);
      }
    }, () {
      print("profile edit fail");
      Fluttertoast.showToast(
          msg: "네트워크 연결이 불안정해 프로필을 수정하지 못했어요. 재연결 후 다시 시도해주세요".tr,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: MyColor.orange_1,
          textColor: Colors.white,
          fontSize: 15.0);
    });

    languagesToAdd.clear();
    languagesToRemove.clear();
    languagesEditMode.value = false;
  }

  void languagesEditManager(Language languageOfInterest) {
    if (languagesToAdd.contains(languageOfInterest)) {
      if (languagesToAdd.length == 1 && languagesToRemove.length == userController.userLanguages.length){
        // leave at least one language
        return;
      }
      languagesToAdd.remove(languageOfInterest);
    } else if (languagesToRemove.contains(languageOfInterest)) {
      languagesToRemove.remove(languageOfInterest);
    } else if (userController.userLanguages.contains(languageOfInterest)) {
      // remove the language from existing list = removing one
      if (languagesToAdd.isEmpty && languagesToRemove.length + 1 == userController.userLanguages.length){
        // leave at least one language
        return;
      }
      languagesToRemove.add(languageOfInterest);
    } else {
      languagesToAdd.add(languageOfInterest);
    }

    languagesToAdd.refresh();
    languagesToRemove.refresh();

    print(userController.userLanguages);
    print("current result: ${languagesToAdd} and ${languagesToRemove}");
  }

  bool languageStatusCheck(Language languageOfInterest) {
    if (languagesToAdd.contains(languageOfInterest) ||
        (userController.userLanguages.contains(languageOfInterest) &&
            !languagesToRemove.contains(languageOfInterest))) {
      return true;
    }
    return false;
  }

  // functions for editing like tags category
  void onLikeTagsEditActivateTap() {
    currentHobby.value = List.from(userController.userProfile.hobbies);
    currentFoodCategory.value = List.from(userController.userProfile.foodCategories);
    currentMovieGenre.value = List.from(userController.userProfile.movieGenres);
    currentLocation.value = List.from(userController.userProfile.locations);

    likeTagsEditMode.value = true;
    // [hobbyToAdd, hobbyToRemove, foodCategoryToAdd, foodCategoryToRemove, movieGenreToAdd, movieGenreToRemove, locationToAdd, locationToRemove].forEach((element) {element.clear();});

  }

  void onLikeTagsEditCompleteTap() async {
    print("tags edit complete");
    // [hobbyToAdd, hobbyToRemove, foodCategoryToAdd, foodCategoryToRemove, movieGenreToAdd, movieGenreToRemove, locationToAdd, locationToRemove].forEach((element) {print(element.value);});

    // need to send server request with all the lists, and update local User.

    Map<String, dynamic> toAddData = {
      "hobby" : [for (Hobby hobby in hobbyToAdd) _$HobbyEnumMap[hobby]],
      "food" : [for (FoodCategory foodCategory in foodCategoryToAdd) _$FoodCategoryEnumMap[foodCategory]],
      "movie" : [for (MovieGenre movieGenre in movieGenreToAdd) _$MovieGenreEnumMap[movieGenre]],
      "location" : [for (Location location in locationToAdd) _$LocationEnumMap[location]],
    };

    Map<String, dynamic> toRemoveData = {
      "hobby" : [for (Hobby hobby in hobbyToRemove) _$HobbyEnumMap[hobby]],
      "food" : [for (FoodCategory foodCategory in foodCategoryToRemove) _$FoodCategoryEnumMap[foodCategory]],
      "movie" : [for (MovieGenre movieGenre in movieGenreToRemove) _$MovieGenreEnumMap[movieGenre]],
      "location" : [for (Location location in locationToRemove) _$LocationEnumMap[location]],
    };

    await _editProfileUseCase.call(toAddData, toRemoveData, () {
      print("profile tags edit success");
      User user = userController.user;

      user.profile.hobbies.addAll(hobbyToAdd);
      user.profile.foodCategories.addAll(foodCategoryToAdd);
      user.profile.movieGenres.addAll(movieGenreToAdd);
      user.profile.locations.addAll(locationToAdd);

      for (Hobby value in hobbyToRemove) user.profile.hobbies.remove(value);
      for (FoodCategory value in foodCategoryToRemove) user.profile.foodCategories.remove(value);
      for (MovieGenre value in movieGenreToRemove) user.profile.movieGenres.remove(value);
      for (Location value in locationToRemove) user.profile.locations.remove(value);


    }, () {
      print("profile tags edit fail");
      Fluttertoast.showToast(
          msg: "네트워크 연결이 불안정해 프로필을 수정하지 못했어요. 재연결 후 다시 시도해주세요".tr,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: MyColor.orange_1,
          textColor: Colors.white,
          fontSize: 15.0);
    });

    print(toAddData);
    print(toRemoveData);

    [hobbyToAdd, hobbyToRemove, foodCategoryToAdd, foodCategoryToRemove, movieGenreToAdd, movieGenreToRemove, locationToAdd, locationToRemove].forEach((element) {element.clear();});
    likeTagsEditMode.value = false;

  }

  final _$HobbyEnumMap = {
    Hobby.painting: 'painting',
    Hobby.gardening: 'gardening',
    Hobby.hiking: 'hiking',
    Hobby.reading: 'reading',
    Hobby.cooking: 'cooking',
    Hobby.photography: 'photography',
    Hobby.dancing: 'dancing',
    Hobby.swimming: 'swimming',
    Hobby.cycling: 'cycling',
    Hobby.traveling: 'traveling',
    Hobby.gaming: 'gaming',
    Hobby.fishing: 'fishing',
    Hobby.knitting: 'knitting',
    Hobby.music: 'music',
    Hobby.yoga: 'yoga',
    Hobby.writing: 'writing',
    Hobby.shopping: 'shopping',
    Hobby.teamSports: 'teamSports',
    Hobby.fitness: 'fitness',
    Hobby.movie: 'movie',
  };

  final _$FoodCategoryEnumMap = {
    FoodCategory.korean: 'korean',
    FoodCategory.spanish: 'spanish',
    FoodCategory.american: 'american',
    FoodCategory.italian: 'italian',
    FoodCategory.thai: 'thai',
    FoodCategory.chinese: 'chinese',
    FoodCategory.japanese: 'japanese',
    FoodCategory.indian: 'indian',
    FoodCategory.mexican: 'mexican',
    FoodCategory.vegan: 'vegan',
    FoodCategory.dessert: 'dessert',
  };

  final _$MovieGenreEnumMap = {
    MovieGenre.action: 'action',
    MovieGenre.adventure: 'adventure',
    MovieGenre.animation: 'animation',
    MovieGenre.comedy: 'comedy',
    MovieGenre.drama: 'drama',
    MovieGenre.fantasy: 'fantasy',
    MovieGenre.horror: 'horror',
    MovieGenre.mystery: 'mystery',
    MovieGenre.romance: 'romance',
    MovieGenre.scienceFiction: 'scienceFiction',
    MovieGenre.thriller: 'thriller',
    MovieGenre.western: 'western',
  };

  final _$LocationEnumMap = {
    Location.humanity: 'humanity',
    Location.naturalScience: 'naturalScience',
    Location.dormitory: 'dormitory',
    Location.socialScience: 'socialScience',
    Location.humanEcology: 'humanEcology',
    Location.agriculture: 'agriculture',
    Location.highEngineering: 'highEngineering',
    Location.lowEngineering: 'lowEngineering',
    Location.business: 'business',
    Location.jahayeon: 'jahayeon',
    Location.studentUnion: 'studentUnion',
    Location.seolYeep: 'seolYeep',
    Location.nockDoo: 'nockDoo',
    Location.bongcheon: 'bongcheon',
  };

  RxList? toAddList(dynamic item) {
    if      (item is Hobby) return hobbyToAdd;
    else if (item is FoodCategory) return foodCategoryToAdd;
    else if (item is MovieGenre) return movieGenreToAdd;
    else if (item is Location) return locationToAdd;
  }

  RxList? toRemoveList(dynamic item) {
    if      (item is Hobby) return hobbyToRemove;
    else if (item is FoodCategory) return foodCategoryToRemove;
    else if (item is MovieGenre) return movieGenreToRemove;
    else if (item is Location) return locationToRemove;
  }

  RxList? currentList(dynamic item) {
    if      (item is Hobby) return currentHobby;
    else if (item is FoodCategory) return currentFoodCategory;
    else if (item is MovieGenre) return currentMovieGenre;
    else if (item is Location) return currentLocation;
  }

  List? userProfileList(dynamic item) {
    if      (item is Hobby) return userController.userProfile.hobbies;
    else if (item is FoodCategory) return userController.userProfile.foodCategories;
    else if (item is MovieGenre) return userController.userProfile.movieGenres;
    else if (item is Location) return userController.userProfile.locations;
  }

  List? fullList(dynamic item) {
    if      (item is Hobby) return Hobby.values;
    else if (item is FoodCategory) return FoodCategory.values;
    else if (item is MovieGenre) return MovieGenre.values;
    else if (item is Location) return Location.values;
  }

  RxBool? editModeBool(dynamic item) {
    if      (item is Hobby) return hobbyAddMode;
    else if (item is FoodCategory) return foodCategoryAddMode;
    else if (item is MovieGenre) return movieGenreAddMode;
    else if (item is Location) return locationAddMode;
  }

  void onAddItemTap(dynamic item){
    RxList toAdd = toAddList(item)!;
    RxList toRemove = toRemoveList(item)!;
    RxList current = currentList(item)!;
    List userList = userProfileList(item)!;
    RxBool editMode = editModeBool(item)!;

    if (!userList.contains(item)) toAdd.add(item);
    toRemove.remove(item);
    current.add(item);
    editMode.value = false;
  }

  void onRemoveItemTap(dynamic item){
    RxList toAdd = (toAddList(item))!;
    RxList toRemove = toRemoveList(item)!;
    RxList current = currentList(item)!;
    List userList = userProfileList(item)!;
    RxBool editMode = editModeBool(item)!;

    if(current.length > 1) {
      if (userList.contains(item)) toRemove.add(item);
      toAdd.remove(item);
      current.remove(item);
    }


  }

  void onLogOutSuccess() {
    Get.find<ChattingRoomListController>()
        .deleteAllValidChattingRoomDependency();
    Get.offAllNamed(Routes.ENTRY);
  }

  ProfileScreenController({required SignOutUseCase signOutUseCase,
    required EditProfileUseCase editProfileUseCase})
      : _signOutUseCase = signOutUseCase,
        _editProfileUseCase = editProfileUseCase;
}
