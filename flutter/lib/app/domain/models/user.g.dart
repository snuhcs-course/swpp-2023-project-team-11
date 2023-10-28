// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KoreanUser _$KoreanUserFromJson(Map<String, dynamic> json) => KoreanUser(
      // id: json['id'] as String,
      name: json['name'] as String,
      userType: $enumDecode(_$UserTypeEnumMap, json['type']),
      email: json['email'] as String,
      wantedLanguages: (json['languages'] as List<dynamic>)
          .map((e) => $enumDecode(_$LanguageEnumMap, e))
          .toList(),
      profile: Profile.fromJson(json['profile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$KoreanUserToJson(KoreanUser instance) =>
    <String, dynamic>{
      // 'id': instance.id,
      'name': instance.name,
      'userType': _$UserTypeEnumMap[instance.userType]!,
      'email': instance.email,
      'profile': instance.profile,
      'languages':
          instance.wantedLanguages.map((e) => _$LanguageEnumMap[e]!).toList(),
    };

const _$UserTypeEnumMap = {
  UserType.korean: 'korean',
  UserType.foreign: 'foreign',
};

const _$LanguageEnumMap = {
  Language.english: 'english',
  Language.spanish: 'spanish',
  Language.chinese: 'chinese',
  Language.arabic: 'arabic',
  Language.french: 'french',
  Language.german: 'german',
  Language.japanese: 'japanese',
  Language.russian: 'russian',
  Language.portuguese: 'portuguese',
  Language.korean: 'korean',
  Language.italian: 'italian',
  Language.dutch: 'dutch',
  Language.swedish: 'swedish',
  Language.turkish: 'turkish',
  Language.hebrew: 'hebrew',
  Language.hindi: 'hindi',
  Language.thai: 'thai',
  Language.greek: 'greek',
  Language.vietnamese: 'vietnamese',
  Language.finnish: 'finnish',
};

ForeignUser _$ForeignUserFromJson(Map<String, dynamic> json) => ForeignUser(
      // id: json['id'] as String,
      name: json['name'] as String,
      userType: $enumDecode(_$UserTypeEnumMap, json['type']),
      email: json['email'] as String,
      nationCode: json['profile']['nation_code'] as int,
      mainLanguage: $enumDecode(_$LanguageEnumMap, json['main_language']),
      subLanguages: (json['languages'] as List<dynamic>)
          .map((e) => $enumDecode(_$LanguageEnumMap, e))
          .toList(),
      profile: Profile.fromJson(json['profile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ForeignUserToJson(ForeignUser instance) =>
    <String, dynamic>{
      // 'id': instance.id,
      'name': instance.name,
      'userType': _$UserTypeEnumMap[instance.userType]!,
      'email': instance.email,
      'profile': instance.profile,
      'nationCode': instance.nationCode,
      'mainLanguage': _$LanguageEnumMap[instance.mainLanguage]!,
      'subLanguages':
          instance.subLanguages.map((e) => _$LanguageEnumMap[e]!).toList(),
    };

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
      birth: DateTime.parse(json['birth'] as String),
      sex: $enumDecode(_$SexEnumMap, json['sex']),
      major: json['major'] as String,
      admissionYear: json['admission_year'] as int,
      aboutMe: json['about_me'] as String,
      mbti: $enumDecode(_$MbtiEnumMap, json['mbti'].toString().toLowerCase()),
      hobbies: (json['hobbies'] as List<dynamic>)
          .map((e) => $enumDecode(_$HobbyEnumMap, e))
          .toList(),
      foodCategories: (json['foods'] as List<dynamic>)
          .map((e) => $enumDecode(_$FoodCategoryEnumMap, e))
          .toList(),
      movieGenres: (json['movies'] as List<dynamic>)
          .map((e) => $enumDecode(_$MovieGenreEnumMap, e))
          .toList(),
      locations: (json['locations'] as List<dynamic>)
          .map((e) => $enumDecode(_$LocationEnumMap, e))
          .toList(),
    );

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'birth': instance.birth.toIso8601String().substring(0, 10),
      'sex': _$SexEnumMap[instance.sex]!,
      'major': instance.major,
      'admissionYear': instance.admissionYear,
      'aboutMe': instance.aboutMe,
      'mbti': _$MbtiEnumMap[instance.mbti]!,
      'hobbies': instance.hobbies.map((e) => _$HobbyEnumMap[e]!).toList(),
      'foodCategories': instance.foodCategories
          .map((e) => _$FoodCategoryEnumMap[e]!)
          .toList(),
      'movieGenres':
          instance.movieGenres.map((e) => _$MovieGenreEnumMap[e]!).toList(),
      'locations':
          instance.locations.map((e) => _$LocationEnumMap[e]!).toList(),
      'imgUrl': instance.imgUrl,
    };

const _$SexEnumMap = {
  Sex.male: 'male',
  Sex.female: 'female',
  Sex.nonBinary: 'nonBinary',
};

const _$MbtiEnumMap = {
  Mbti.intj: 'intj',
  Mbti.intp: 'intp',
  Mbti.entj: 'entj',
  Mbti.entp: 'entp',
  Mbti.infj: 'infj',
  Mbti.infp: 'infp',
  Mbti.enfj: 'enfj',
  Mbti.enfp: 'enfp',
  Mbti.istj: 'istj',
  Mbti.isfj: 'isfj',
  Mbti.estj: 'estj',
  Mbti.esfj: 'esfj',
  Mbti.istp: 'istp',
  Mbti.isfp: 'isfp',
  Mbti.estp: 'estp',
  Mbti.esfp: 'esfp',
  Mbti.unknown: 'unknown',
};

const _$HobbyEnumMap = {
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

const _$FoodCategoryEnumMap = {
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

const _$MovieGenreEnumMap = {
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

const _$LocationEnumMap = {
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
