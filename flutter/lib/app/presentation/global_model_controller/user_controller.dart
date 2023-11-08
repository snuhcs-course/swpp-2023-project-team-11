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
}