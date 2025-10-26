import 'package:aipply/core/home/domain/question.dart';
import 'package:aipply/network/api_repository.dart';
import 'package:flutter/widgets.dart';

class QuestionGeneratorController with ChangeNotifier {
  final apiRepo = ApiRepository();

  Future<List<Question>> generateQuestions(
    String jobDescription,
    String experienceLevel,
  ) async {
    List<Question> questions = [];
    if (jobDescription.isNotEmpty) {
      final payload = {
        "job_description": jobDescription,
        "name": "Akindele",
        "experience_level": "mid",
      };

      questions = await apiRepo.generateQuestions(payload: payload);
    }

    return questions;
  }
}
