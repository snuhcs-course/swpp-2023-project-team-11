abstract class Advice {
  final String id;
  final String text;
  final DateTime createdAt;
  final AdviceType adviceType;

  const Advice({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.adviceType,
  });
}

enum AdviceType{
  topic,
  mission
}