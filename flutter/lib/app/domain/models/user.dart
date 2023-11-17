import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';


abstract class User {
  // final String id;
  final String name;
  final UserType type;
  final String email;
  final Profile profile;

  const User({
    // required this.id,
    required this.name,
    required this.type,
    required this.email,
    required this.profile,
  });


  factory User.fromMap(Map<String, dynamic> map) {
    final userType = UserType.values.byName(map["type"]);
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
  @JsonKey(name: "languages")
  final List<Language> wantedLanguages;
  final Language mainLanguage;

  KoreanUser({
    // required super.id,
    required super.name,
    required super.type,
    required super.email,
    required this.wantedLanguages,
    required this.mainLanguage,
    required super.profile,
  });

  factory KoreanUser.fromJson(Map<String, dynamic> json) => _$KoreanUserFromJson(json);
  Map<String, dynamic> toJson() => _$KoreanUserToJson(this);


  @override
  int get getNationCode => 82;

  @override
  Language get getMainLanguage => mainLanguage;

  @override
  // TODO: implement getLanguages
  List<Language> get getLanguages => wantedLanguages;
}
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ForeignUser extends User {
  @JsonKey(name: "main_language")
  final Language mainLanguage;
  @JsonKey(name : "languages")
  final List<Language> subLanguages;


  ForeignUser({
    // required super.id,
    required super.name,
    required super.type,
    required super.email,
    required this.mainLanguage,
    required this.subLanguages,
    required super.profile,
  });

  factory ForeignUser.fromJson(Map<String, dynamic> json) => _$ForeignUserFromJson(json);
  Map<String, dynamic> toJson() => _$ForeignUserToJson(this);

  @override
  int get getNationCode => profile.nationCode;

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
  korean ("Korean", "한국어"), english ("English", "영어"), spanish ("Spanish", "스페인어"),
  chinese ("Chinese", "중국어"), arabic ("Arabic", "아랍어"), french ("French", "프랑스어"),
  german ("German", "독일어"), japanese ("Japanese", "일본어"), russian ("Russian", "러시아어"),
  portuguese ("Portuguese", "포르투갈어"), italian ("Italian", "이탈리아어"), dutch ("Dutch", "네덜란드어"),
  swedish ("Swedish", "스웨덴어"), turkish ("Turkish", "터키어"), hebrew ("Hebrew", "히브리어"), hindi ("Hindi", "힌디어"),
  thai ("Thai", "태국어"), greek ("Greek", "그리스어"), vietnamese ("Vietnamese", "베트남어"), finnish ("Finnish", "핀란드어");

  final String krName;
  final String enName;

  const Language(this.enName, this.krName);

  @override
  String toString() {
    return name;
  }
}

enum Mbti {
  INTJ ("INTJ"), INTP ("INTP"), ENTJ ("ENTJ"), ENTP ("ENTP"),
  INFJ ("INFJ"), INFP ("INFP"), ENFJ ("ENFJ"), ENFP ("ENFP"),
  ISTJ ("ISTJ"), ISFJ ("ISFJ"), ESTJ ("ESTJ"), ESFJ ("ESFJ"),
  ISTP ("ISTP"), ISFP ("ISFP"), ESTP ("ESTP"), ESFP ("ESFP"), UNKNOWN ("UNKNOWN");

  final String name;

  const Mbti(this.name);

  @override
  String toString() {
    return name;
  }
}
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Profile {
  final DateTime birth;
  final Sex sex;
  final String major;
  final int admissionYear;
  final String aboutMe;
  final Mbti mbti;

  final int nationCode;
  final List<Hobby> hobbies;
  @JsonKey(name: "foods")
  final List<FoodCategory> foodCategories;
  @JsonKey(name: "movies")
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
    required this.nationCode,
    this.imgUrl,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}

enum Sex {
  male("남성","male"),
  female("여성","female"),
  nonBinary("논바이너리","non_binary");

  final String krName;
  final String enName;
  const Sex(this.krName,this.enName);

  @override
  String toString() => enName;
}

enum FoodCategory {
  korean("Korean","한식"),
  spanish("Spanish","스페인 음식"),
  american("American","미국식 음식"),
  italian("Italian","양식"),
  thai("Thai","동남아 음식"),
  chinese("Chinese","중식"),
  japanese("Japanese","일식"),
  indian("Indian","인도 음식"),
  mexican("Mexican","멕시코 음식"),
  vegan("Vegan","채식"),
  dessert("Dessert","디저트 류");

  final String enName;
  final String krName;
  const FoodCategory(this.enName, this.krName);

  @override
  String toString() => krName;
}

enum MovieGenre {
  action("Action","액션"),
  adventure("Adventure","어드벤처"),
  animation("Animation","애니"),
  comedy("Comedy","코미디"),
  drama("Drama","드라마"),
  fantasy("Fantasy","판타지"),
  horror("Horror","공포"),
  mystery("Mystery","미스터리"),
  romance("Romance","로맨스"),
  scienceFiction("ScienceFiction","SF"),
  thriller("Thriller","스릴러"),
  western("Western","서부극");

  final String krName;
  final String enName;
  const MovieGenre(this.enName, this.krName);

  @override
  String toString() => krName;
}

enum Hobby {
  painting("Painting","그림 그리기"),
  gardening("Gardening", "정원 가꾸기"),
  hiking("Hiking", "등산"),
  reading("Reading", "독서"),
  cooking("Cooking", "요리"),
  photography("Photography", "사진 찍기"),
  dancing("Dancing", "춤추기"),
  swimming("Swimming", "수영"),
  cycling("Cycling", "자전거 타기"),
  traveling("Traveling", "여행"),
  gaming("Gaming", "게임"),
  fishing("Fishing", "낚시"),
  knitting("Knitting", "뜨개질"),
  music("Music", "노래"),
  yoga("Yoga", "요가"),
  writing("Writing", "글쓰기"),
  shopping("Shopping", "쇼핑"),
  teamSports("Team Sports", "팀 운동"),
  fitness("Fitness", "헬스"),
  movie("Movie", "영화 보기");

  final String enName;
  final String krName;

  const Hobby(this.enName, this.krName);

  @override
  String toString() {
    return krName;
  }
}

enum Location {
  humanity("Humanity", "인문대"),
  naturalScience("Natural Science", "자연대"),
  dormitory("Dormitory", "기숙사"),
  socialScience("Social SCience","사회과학대"),
  humanEcology("Human Ecology", "생활대"),
  agriculture("Agriculture", "농대"),
  highEngineering("High Engineering", "윗 공대"),
  lowEngineering("Low Engineering", "아랫 공대"),
  business("Business", "경영대"),
  jahayeon("Jahayeon", "자하연"),
  studentUnion("Student Union", "학생회관"),
  seolYeep("Seoul Nat'l Station","설입"),
  nockDoo("Nockdoo (Daehak-dong)", "녹두"),
  bongcheon("Bongcheon Station","봉천");

  final String enName;
  final String krName;

  const Location(this.enName, this.krName);

  @override
  String toString() => krName;
}

