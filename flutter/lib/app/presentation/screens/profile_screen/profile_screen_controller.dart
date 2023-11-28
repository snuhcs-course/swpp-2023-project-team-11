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

  final RxList<Language> toAdd = <Language>[].obs;
  final RxList<Language> toRemove = <Language>[].obs;

  void onLogOutButtonTap() async {
    LoadingUtil.withLoadingOverlay(asyncFunction: () async {
      await _signOutUseCase.call(onSuccess: onLogOutSuccess);
    });
  }

  void onProfileEditActivateTap() async {
    print("need to erase this function");
    // languagesEditMode.value = false;
  }

  // functions for editing languages category
  void onLanguagesEditActivateTap() {
    languagesEditMode.value = true;
  }

  void onLanguagesEditCompleteTap() async {
    // need to call update user profile at the repo at this point
    // print(toAdd.value);
    List<String> toAddString = [];
    toAdd.forEach((element) {toAddString.add(element.enName.toLowerCase());});
    List<String> toRemoveString = [];
    toRemove.forEach((element) {toRemoveString.add(element.enName.toLowerCase());});

    print("add: ${toAddString}, remove: ${toRemoveString}");

    await _editProfileUseCase
        .call({"lang": toAddString}, {"lang": toRemoveString}, () {
      print("profile edit success");
    }, () {
      print("profile edit fail");
    });

    User user = userController.user;
    user.getLanguages.addAll(toAdd);
    for (Language l in toRemove) {
      user.getLanguages.remove(l);
    }

    toAdd.clear();
    toRemove.clear();

    print("language edit complete");
    languagesEditMode.value = false;
  }



  void languagesEditManager(Language languageOfInterest) {
    if (toAdd.contains(languageOfInterest)) {
      toAdd.remove(languageOfInterest);
    } else if (toRemove.contains(languageOfInterest)) {
      toRemove.remove(languageOfInterest);
    } else if (userController.userLanguages.contains(languageOfInterest)) {
      toRemove.add(languageOfInterest);
    } else {
      toAdd.add(languageOfInterest);
    }

    toAdd.refresh();
    toRemove.refresh();

    print(userController.userLanguages);
    print("current result: ${toAdd} and ${toRemove}");
  }

  bool languageStatusCheck(Language languageOfInterest) {
    if (toAdd.contains(languageOfInterest) ||
        (userController.userLanguages.contains(languageOfInterest) &&
            !toRemove.contains(languageOfInterest))) {
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

  ProfileScreenController({required SignOutUseCase signOutUseCase,
    required EditProfileUseCase editProfileUseCase})
      : _signOutUseCase = signOutUseCase,
        _editProfileUseCase = editProfileUseCase;
}
