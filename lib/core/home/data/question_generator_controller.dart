import 'package:aipply/network/api_repository.dart';
import 'package:flutter/widgets.dart';

class QuestionGeneratorController with ChangeNotifier {
  final _apiRepo = ApiRepository();

  Future<(List<String>, String)> generateQuestions(
    String jobDescription,
    String experienceLevel,
  ) async {
    List<String> questions = [];
    String errorMsg = '';
    if (jobDescription.isNotEmpty && experienceLevel.isNotEmpty) {
      // if(experienceLevel == "newr")
      final payload = {
        "job_description": jobDescription,
        "name": "Akindele",
        "experience_level": "mid",
      };

      final (questionsFromApi, errMsg) = await _apiRepo.generateQuestions(
        payload: payload,
      );

      // convert to string
      for (var question in questionsFromApi) {
        questions.add(question.question);
      }
      errorMsg = errMsg;
    }

    return (questions, errorMsg);
  }
}
