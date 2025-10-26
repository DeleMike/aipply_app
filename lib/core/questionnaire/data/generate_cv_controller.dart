import 'dart:convert';

import 'package:aipply/core/questionnaire/domain/cv_document.dart';
import 'package:flutter/material.dart';

import '../../../network/api_repository.dart';
import '../../../utils/debug_fns.dart';

class GenerateCvController with ChangeNotifier {
  final _apiRepo = ApiRepository();

  Future<CVDocument> generateCV(
    String jobDescription,
    List<Map<String, dynamic>> answers,
  ) async {
    await Future.delayed(const Duration(seconds: 2));

    final payload = {"job_description": jobDescription, "answers": answers};

    printOut('Payload for Cover Letter = ${jsonEncode(payload)})');

    final cv = await _apiRepo.generateCV(payload: payload);

    return cv;
  }
}
