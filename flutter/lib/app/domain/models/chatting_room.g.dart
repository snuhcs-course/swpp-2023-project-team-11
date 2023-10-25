// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatting_room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChattingRoom _$ChattingRoomFromJson(Map<String, dynamic> json) => ChattingRoom(
      id: json['id'] as String,
      koreanUser:
          KoreanUser.fromJson(json['koreanUser'] as Map<String, dynamic>),
      foreignUser:
          ForeignUser.fromJson(json['foreignUser'] as Map<String, dynamic>),
      friendship:
          Friendship.fromJson(json['friendship'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ChattingRoomToJson(ChattingRoom instance) =>
    <String, dynamic>{
      'id': instance.id,
      'koreanUser': instance.koreanUser,
      'foreignUser': instance.foreignUser,
      'friendship': instance.friendship,
      'createdAt': instance.createdAt.toIso8601String(),
    };
