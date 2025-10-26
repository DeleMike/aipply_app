class QA {
  final String question;
  final String answer;

  QA({required this.question, required this.answer});

  Map<String, dynamic> toJson() => {'question': question, 'answer': answer};
}
