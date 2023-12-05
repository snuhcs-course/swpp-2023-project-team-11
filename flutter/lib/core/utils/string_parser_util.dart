import 'dart:convert';

import 'package:get/get.dart';
import 'package:mobile_app/app/domain/models/topic.dart';
import 'package:mobile_app/core/constants/system_strings.dart';
import 'package:mobile_app/core/utils/translation.dart';

class StringParserUtil {
  static String buildRoadmapText(String text) {

    if (!text.startsWith(roadmap_prefix)) return text;

    Topic topic = Topic.fromJson(
        jsonDecode(text.replaceFirst(roadmap_prefix, "")));

    String topic_string = MyLanguageUtil.isKr ? topic.topic_kor : topic.topic_eng;
    return "${topic_string}";
  }
}
