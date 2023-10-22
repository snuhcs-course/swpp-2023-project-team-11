import 'package:mobile_app/app/domain/models/friendship.dart';
import 'package:mobile_app/app/domain/models/user.dart';

class ChattingRoom {
  final String id;
  final KoreanUser koreanUser;
  final ForeignUser foreignUser;
  final Friendship friendship;
  final DateTime createdAt;

  const ChattingRoom({
    required this.id,
    required this.koreanUser,
    required this.foreignUser,
    required this.friendship,
    required this.createdAt,
  });
}

