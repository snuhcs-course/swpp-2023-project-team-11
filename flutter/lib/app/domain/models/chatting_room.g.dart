// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatting_room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChattingRoom _$ChattingRoomFromJson(Map<String, dynamic> json) => ChattingRoom(
      id: json['chatting_id'] as String,
      initiator: User.fromMap(json['initiator'] as Map<String, dynamic>),
      responder: User.fromMap(json['responder'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['created_at'] as String),
      isApproved: json['is_approved'] as bool,
      isTerminated: json['is_terminated'] as bool,
    );
