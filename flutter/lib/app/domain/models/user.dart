import 'package:json_annotation/json_annotation.dart';
import 'package:mobile_app/core/themes/color_theme.dart';

part 'user.g.dart';


abstract class User {
  final String id;
  final String name;
  final UserType userType;
  final String email;
  final Profile profile;

  const User({
    required this.id,
    required this.name,
    required this.userType,
    required this.email,
    required this.profile,
  });


  factory User.fromMap(Map<String, dynamic> map) {
    final userType = UserType.values.byName(map["user_type"]);
    if (userType == UserType.korean) {
      return KoreanUser.fromJson(map);
    } else {
      return ForeignUser.fromJson(map);
    }
  }

  int get getNationCode;

  Language get getMainLanguage;

  List<Language> get getLanguages;
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class KoreanUser extends User {
  final List<Language> wantedLanguages;

  KoreanUser({
    required super.id,
    required super.name,
    required super.userType,
    required super.email,
    required this.wantedLanguages,
    required super.profile,
  });

  factory KoreanUser.fromJson(Map<String, dynamic> json) => _$KoreanUserFromJson(json);
  Map<String, dynamic> toJson() => _$KoreanUserToJson(this);


  @override
  int get getNationCode => 82;

  @override
  Language get getMainLanguage => Language.korean;

  @override
  // TODO: implement getLanguages
  List<Language> get getLanguages => wantedLanguages;
}
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ForeignUser extends User {
  final int nationCode;
  final Language mainLanguage;
  final List<Language> subLanguages;

  ForeignUser({
    required super.id,
    required super.name,
    required super.userType,
    required super.email,
    required this.nationCode,
    required this.mainLanguage,
    required this.subLanguages,
    required super.profile,
  });

  factory ForeignUser.fromJson(Map<String, dynamic> json) => _$ForeignUserFromJson(json);
  Map<String, dynamic> toJson() => _$ForeignUserToJson(this);

  @override
  int get getNationCode => nationCode;

  @override
  // TODO: implement getMainLanguage
  Language get getMainLanguage => mainLanguage;

  @override
  // TODO: implement getLanguages
  List<Language> get getLanguages => subLanguages;
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

enum Mbti {
  intj,
  intp,
  entj,
  entp,
  infj,
  infp,
  enfj,
  enfp,
  istj,
  isfj,
  estj,
  esfj,
  istp,
  isfp,
  estp,
  esfp,
  unknown,
}
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Profile {
  final DateTime birth;
  final Sex sex;
  final String major;
  final int admissionYear;
  final String aboutMe;
  final Mbti mbti;
  final List<Hobby> hobbies;
  final List<FoodCategory> foodCategories;
  final List<MovieGenre> movieGenres;
  final List<Location> locations;
  final String? imgUrl;


  const Profile({
    required this.birth,
    required this.sex,
    required this.major,
    required this.admissionYear,
    required this.aboutMe,
    required this.mbti,
    required this.hobbies,
    required this.foodCategories,
    required this.movieGenres,
    required this.locations,
    this.imgUrl,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}

enum Sex {
  male,
  female,
  nonBinary,
}

enum FoodCategory {
  korean("한식"),
  spanish("스페인 음식"),
  american("미국식 음식"),
  italian("양식"),
  thai("동남아 음식"),
  chinese("중식"),
  japanese("일식"),
  indian("인도 음식"),
  mexican("멕시코 음식"),
  vegan("채식"),
  dessert("디저트 류");

  final String krName;
  const FoodCategory(this.krName);

  @override
  String toString() => krName;
}

enum MovieGenre {
  action("액션"),
  adventure("어드벤처"),
  animation("애니"),
  comedy("코미디"),
  drama("드라마"),
  fantasy("판타지"),
  horror("공포"),
  mystery("미스터리"),
  romance("로맨스"),
  scienceFiction("SF"),
  thriller("스릴러"),
  western("서부극");

  final String krName;
  const MovieGenre(this.krName);

  @override
  String toString() => krName;
}

enum Hobby {
  painting("그림 그리기"),
  gardening("정원 가꾸기"),
  hiking("등산"),
  reading("독서"),
  cooking("요리"),
  photography("사진 찍기"),
  dancing("춤추기"),
  swimming("수영"),
  cycling("자전거 타기"),
  traveling("여행"),
  gaming("게임"),
  fishing("낚시"),
  knitting("뜨개질"),
  music("노래"),
  yoga("요가"),
  writing("글쓰기"),
  shopping("쇼핑"),
  teamSports("팀 운동"),
  fitness("헬스"),
  movie("영화 보기");

  final String krName;

  const Hobby(this.krName);

  @override
  String toString() {
    return krName;
  }
}

enum Location {
  humanity("인문대"),
  naturalScience("자연대"),
  dormitory("기숙사"),
  socialScience("사회과학대"),
  humanEcology("생활대"),
  agriculture("농대"),
  highEngineering("윗 공대"),
  lowEngineering("아랫 공대"),
  business("경영대"),
  jahayeon("자하연"),
  studentUnion("학생회관"),
  seolYeep("설입"),
  nockDoo("녹두"),
  bongcheon("봉천");

  final String krName;

  const Location(this.krName);

  @override
  String toString() => krName;
}

