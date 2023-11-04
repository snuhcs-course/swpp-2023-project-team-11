import 'dart:math';

import 'package:mobile_app/app/domain/models/chatting_room.dart';
import 'package:mobile_app/app/domain/repository_interfaces/chatting_room_repository.dart';
import 'package:mobile_app/app/domain/result.dart';

import '../../../domain/models/friendship.dart';
import '../../../domain/models/user.dart';

class ChattingRepositoryMock implements ChattingRepository {
  List<ChattingRoom> generateRandomChattingRoomTestCases(int count) {
    final List<ChattingRoom> testCases = [];

    final random = Random();

    for (int i = 0; i < count; i++) {
      final koreanUser = KoreanUser(
          name: 'KoreanUserName$i',
          type: UserType.korean,
          email: 'korean.user$i@example.com',
          mainLanguage: Language.korean,
          wantedLanguages: [
            Language.values[random.nextInt(Language.values.length)],
            Language.values[random.nextInt(Language.values.length)],
          ],
          profile: Profile(
              birth: DateTime(1990 + random.nextInt(10), 1, 1),
              sex: Sex.values[random.nextInt(Sex.values.length)],
              nationCode: 82,
              major: 'KoreanMajor$i',
              admissionYear: 2010 + random.nextInt(10),
              aboutMe: 'About Korean User $i',
              mbti: Mbti.values[random.nextInt(Mbti.values.length)],
              hobbies: [Hobby.values[random.nextInt(Hobby.values.length)]],
              foodCategories: [FoodCategory.values[random.nextInt(FoodCategory.values.length)]],
              movieGenres: [MovieGenre.values[random.nextInt(MovieGenre.values.length)]],
              locations: [Location.values[random.nextInt(Location.values.length)]]));

      final foreignUser = ForeignUser(
        name: 'ForeignUserName$i',
        type: UserType.foreign,
        email: 'foreign.user$i@example.com',

        mainLanguage: Language.values[random.nextInt(Language.values.length)],
        subLanguages: [
          Language.values[random.nextInt(Language.values.length)],
          Language.values[random.nextInt(Language.values.length)],
        ],
        profile: Profile(
            nationCode: random.nextInt(1000),
            birth: DateTime(1980 + random.nextInt(10), 1, 1),
            sex: Sex.values[random.nextInt(Sex.values.length)],
            major: 'ForeignMajor$i',
            admissionYear: 2010 + random.nextInt(10),
            aboutMe: 'About Foreign User $i',
            mbti: Mbti.values[random.nextInt(Mbti.values.length)],
            hobbies: [Hobby.values[random.nextInt(Hobby.values.length)]],
            foodCategories: [FoodCategory.values[random.nextInt(FoodCategory.values.length)]],
            movieGenres: [MovieGenre.values[random.nextInt(MovieGenre.values.length)]],
            locations: [Location.values[random.nextInt(Location.values.length)]]),
      );

      final friendship = Friendship(
        intimacy: random.nextDouble() * 5.0,
        recentTopics: [
          'Topic${random.nextInt(10)}',
          'Topic${random.nextInt(10)}',
          'Topic${random.nextInt(10)}',
        ],
      );

      final room = ChattingRoom(
        id: i,
        initiator: koreanUser,
        responder: foreignUser,
        createdAt: DateTime(2023, 10, random.nextInt(31) + 1),
        isApproved: true,
        isTerminated: true,
      );

      testCases.add(room);
    }

    return testCases;
  }

  @override
  Future<Result<List<ChattingRoom>, DefaultIssue>> readAllWhereApproved() {
    // TODO: implement readAllWhereApproved
    throw UnimplementedError();
  }

  @override
  Future<Result<List<ChattingRoom>, DefaultIssue>> readAllWhereNotApproved() {
    // TODO: implement readAllWhereNotApproved
    throw UnimplementedError();
  }

  @override
  Future<Result<ChattingRoom, DefaultIssue>> createChattingRoom({required String counterPartEmail}) {
    // TODO: implement createChattingRoom
    throw UnimplementedError();
  }

  @override
  Future<Result<ChattingRoom, DefaultIssue>> updateChattingRoom({required String chattingRoomId}) {
    // TODO: implement updateChattingRoom
    throw UnimplementedError();
  }
}
