import 'package:json_annotation/json_annotation.dart';

part 'intimacy.g.dart';

@JsonSerializable()
class Intimacy{
  @JsonKey(name: "chatting_id")
  final double chattingRoomId;
  @JsonKey(name: "intimacy")
  final double intimacy;
  @JsonKey(name: "timestamp")
  final DateTime timestamp;

  factory Intimacy.fromJson(Map<String, dynamic> json) => _$IntimacyFromJson(json);

  Map<String, dynamic> toJson() => _$IntimacyToJson(this);

  const Intimacy({
    required this.chattingRoomId,
    required this.intimacy,
    required this.timestamp,
  });
}