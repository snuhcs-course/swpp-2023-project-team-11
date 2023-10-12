abstract class User {
  final String id;
  final String name;
  final String major;
  final UserType userType;
  final String email;
  final List<String> hobbyTags;
  final List<String> mainSites;
  final List<int> mbtiFigures;

  const User({
    required this.id,
    required this.name,
    required this.major,
    required this.userType,
    required this.email,
    required this.hobbyTags,
    required this.mainSites,
    required this.mbtiFigures,
  });
}

class KoreanUser extends User {
  final List<Language> wantedLanguages;

  KoreanUser({
    required super.id,
    required super.name,
    required super.major,
    required super.userType,
    required super.email,
    required super.hobbyTags,
    required super.mainSites,
    required super.mbtiFigures,
    required this.wantedLanguages,
  });
}

class ForeignUser extends User {
  final int nationCode;
  final Language mainLanguage;
  final List<Language> subLanguages;
  ForeignUser({
    required super.id,
    required super.name,
    required super.major,
    required super.userType,
    required super.email,
    required super.hobbyTags,
    required super.mainSites,
    required super.mbtiFigures,
    required this.nationCode,
    required this.mainLanguage,
    required this.subLanguages,
  });
}

enum UserType {
  korean,
  foreign,
}

enum Language {
  english,
  spanish,
  chinese,
  arabic,
  french,
  german,
  japanese,
  russian,
  portuguese,
  korean,
  italian,
  dutch,
  swedish,
  turkish,
  hebrew,
  hindi,
  thai,
  greek,
  vietnamese,
  finnish,
}
