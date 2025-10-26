import 'package:aipply/core/home/domain/question.dart';
import 'package:aipply/network/api_repository.dart';
import 'package:flutter/widgets.dart';

class QuestionGeneratorController with ChangeNotifier {
  final apiRepo = ApiRepository();

  Future<List<String>> generateQuestions(
    String jobDescription,
    String experienceLevel,
  ) async {
    List<String> questions = [];
    if (jobDescription.isNotEmpty && experienceLevel.isNotEmpty) {
      // if(experienceLevel == "newr")
      final payload = {
        "job_description": jobDescription,
        "name": "Akindele",
        "experience_level": "mid",
      };

      final questionsFromApi = await apiRepo.generateQuestions(payload: payload);

      // convert to string
      for (var question in questionsFromApi) {
        questions.add(question.question);
      }
    }

    return questions;
  }
}
