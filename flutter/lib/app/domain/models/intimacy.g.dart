// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intimacy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Intimacy _$IntimacyFromJson(Map<String, dynamic> json) => Intimacy(
      chattingRoomId: (json['chatting_id'] as num).toDouble(),
      intimacy: (json['intimacy'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$IntimacyToJson(Intimacy instance) => <String, dynamic>{
      'chatting_id': instance.chattingRoomId,
      'intimacy': instance.intimacy,
      'timestamp': instance.timestamp.toIso8601String(),
    };
