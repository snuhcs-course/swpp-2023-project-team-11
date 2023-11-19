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
    for (Language l in toRemove.value) {
      user.getLanguages.remove(l);
    }

    toAdd.value.clear();
    toRemove.value.clear();

    print("language edit complete");
    languagesEditMode.value = false;
  }

  final RxList<Language> toAdd = <Language>[].obs;
  final RxList<Language> toRemove = <Language>[].obs;

  void languagesEditManager(Language languageOfInterest) {
    if (toAdd.value.contains(languageOfInterest)) {
      toAdd.value.remove(languageOfInterest);
    } else if (toRemove.value.contains(languageOfInterest)) {
      toRemove.value.remove(languageOfInterest);
    } else if (userController.userLanguages.contains(languageOfInterest)) {
      toRemove.value.add(languageOfInterest);
    } else {
      toAdd.value.add(languageOfInterest);
    }

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
