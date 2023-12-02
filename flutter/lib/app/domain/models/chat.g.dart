// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chat _$ChatFromJson(Map<String, dynamic> json) => Chat(
      seqId: json['seq_id'] as int,
      chattingRoomId: json['chatting_id'] as int,
      senderName: json['sender'] as String,
      senderEmail: json['email'] as String,
      message: json['msg'] as String,
      sentAt: DateTime.parse(json['timestamp'] as String),
      proxyId: json['proxy_id'] as int,
    );

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
      'seq_id': instance.seqId,
      'chatting_id': instance.chattingRoomId,
      'sender': instance.senderName,
      'email': instance.senderEmail,
      'msg': instance.message,
      'timestamp': instance.sentAt.toIso8601String(),
      'proxy_id': instance.proxyId,
    };
