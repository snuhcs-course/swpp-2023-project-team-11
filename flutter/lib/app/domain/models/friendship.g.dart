// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friendship.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Friendship _$FriendshipFromJson(Map<String, dynamic> json) => Friendship(
      intimacy: (json['intimacy'] as num).toDouble(),
      recentTopics: (json['recentTopics'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$FriendshipToJson(Friendship instance) =>
    <String, dynamic>{
      'intimacy': instance.intimacy,
      'recentTopics': instance.recentTopics,
    };
