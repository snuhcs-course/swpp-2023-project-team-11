import 'package:mobile_app/app/domain/models/user.dart';
import 'package:mobile_app/app/domain/repository_interfaces/user_repository.dart';
import 'package:mobile_app/app/domain/result.dart';

import 'dart:math';

class UserRepositoryMock implements UserRepository {
  @override
  Future<User> readUserBySessionId() {
    throw UnimplementedError();
  }

  List<User> generateRandomUsers(int count) {
    final List<User> users = [];

    final random = Random();
    for (var i = 0; i < count; i++) {
      if (random.nextBool()) {
        users.add(KoreanUser(
          id: 'KoreanUserID$i',
          name: 'KoreanUserName$i',
          userType: UserType.korean,
          email: 'korean.user$i@example.com',
          wantedLanguages: [Language.values[i % Language.values.length]],
          profile: Profile(
            birth: DateTime(1990, 1, 1),
            sex: Sex.values[i % Sex.values.length],
            major: 'KoreanMajor$i',
            admissionYear: 2010 + i,
            aboutMe: 'About Korean User $i',
            mbti: Mbti.values[i % Mbti.values.length],
            hobbies: [Hobby.values[i % Hobby.values.length]],
            foodCategories: [FoodCategory.values[i % FoodCategory.values.length]],
            movieGenres: [MovieGenre.values[i % MovieGenre.values.length]],
            locations: [Location.values[i % Location.values.length]],
            imgUrl: null,
          ),
        ));
      } else {
        users.add(ForeignUser(
          id: 'ForeignUserID$i',
          name: 'ForeignUserName$i',
          userType: UserType.foreign,
          email: 'foreign.user$i@example.com',
          nationCode: i,
          mainLanguage: Language.values[i % Language.values.length],
          subLanguages: [Language.values[(i + 1) % Language.values.length]],
          profile: Profile(
            birth: DateTime(1995, 1, 1),
            sex: Sex.values[i % Sex.values.length],
            major: 'ForeignMajor$i',
            admissionYear: 2015 + i,
            aboutMe: 'About Foreign User $i',
            mbti: Mbti.values[i % Mbti.values.length],
            hobbies: [Hobby.values[i % Hobby.values.length]],
            foodCategories: [FoodCategory.values[i % FoodCategory.values.length]],
            movieGenres: [MovieGenre.values[i % MovieGenre.values.length]],
            locations: [Location.values[i % Location.values.length]],
            imgUrl: null,
          ),
        ));
      }
    }

    return users;
  }

  @override
  Future<Result<List<User>, DefaultIssue>> readUsersBasedOnLogic() async{

    List<User> users = await Future.delayed(Duration(seconds: 2)).then((value) => generateRandomUsers(6));

    return Result.success(users);
  }

}