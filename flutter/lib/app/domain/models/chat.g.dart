// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NormalChat _$NormalChatFromJson(Map<String, dynamic> json) => NormalChat(
      messageType: $enumDecode(_$ChatTypeEnumMap, json['messageType']),
      id: json['id'] as String,
      text: json['text'] as String,
      senderId: json['senderId'] as String,
      sentAt: DateTime.parse(json['sentAt'] as String),
    );

Map<String, dynamic> _$NormalChatToJson(NormalChat instance) =>
    <String, dynamic>{
      'messageType': _$ChatTypeEnumMap[instance.messageType]!,
      'id': instance.id,
      'senderId': instance.senderId,
      'text': instance.text,
      'sentAt': instance.sentAt.toIso8601String(),
    };

const _$ChatTypeEnumMap = {
  ChatType.normal: 'normal',
};
