import 'package:get/get.dart';
import 'package:mobile_app/app/domain/models/user.dart';

class UserController extends GetxController {
  final User _user;

  UserController({
    required User user,
  }) : _user = user;

  String get userName => _user.name;
  String get userAboutMe => _user.profile.aboutMe;
  String get userEmail => _user.email;
  Profile get userProfile => _user.profile;
  Language get userMainLanguage => _user.getMainLanguage;
  List<Language> get userLanguages => _user.getLanguages;

  // 진짜 정말 별로인 방법이지만 프로필 편집하느라 유저가 바로 필요해서..
  User get user => _user;

}