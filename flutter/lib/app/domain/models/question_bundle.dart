import 'package:json_annotation/json_annotation.dart';

class QuestionBundle<E extends Enum> {
  final List<String> questions;
  final List<E> answerOptions;

  QuestionBundle({
    required this.questions,
    required this.answerOptions,
  });
  Type get getAnswerType => E;
}