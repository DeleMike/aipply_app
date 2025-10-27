import 'dart:convert';

import 'package:aipply/core/questionnaire/domain/cover_letter_document.dart';
import 'package:aipply/utils/debug_fns.dart';
import 'package:flutter/foundation.dart';

import '../../../network/api_repository.dart';

class GenerateCoverLetterController with ChangeNotifier {
  final _apiRepo = ApiRepository();

  Future<(CoverLetterDocument, String)> generateCoverLetter(
    String jobDescription,
    List<Map<String, dynamic>> answers,
  ) async {
    await Future.delayed(const Duration(seconds: 2));

    final payload = {"job_description": jobDescription, "answers": answers};

    printOut('Payload for Cover Letter = ${jsonEncode(payload)})');

    final (coverLetter, errorMsg) = await _apiRepo.generateCoverLetter(payload: payload);

    return (coverLetter, errorMsg);
  }
}
