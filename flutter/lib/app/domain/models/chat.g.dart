// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NormalChat _$NormalChatFromJson(Map<String, dynamic> json) => NormalChat(
      messageType: $enumDecode(_$ChatTypeEnumMap, json['message_type']),
      id: json['id'] as String,
      text: json['text'] as String,
      senderId: json['sender_id'] as String,
      sentAt: DateTime.parse(json['sent_at'] as String),
    );

Map<String, dynamic> _$NormalChatToJson(NormalChat instance) =>
    <String, dynamic>{
      'message_type': _$ChatTypeEnumMap[instance.messageType]!,
      'id': instance.id,
      'sender_id': instance.senderId,
      'text': instance.text,
      'sent_at': instance.sentAt.toIso8601String(),
    };

const _$ChatTypeEnumMap = {
  ChatType.normal: 'normal',
};
