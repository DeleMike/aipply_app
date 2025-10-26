import 'dart:convert';
import 'dart:io';

import 'package:aipply/core/home/domain/question.dart';
import 'package:aipply/core/questionnaire/domain/cover_letter_document.dart';
import 'package:aipply/core/questionnaire/domain/cv_document.dart';
import 'package:aipply/network/aipply_api.dart';
import 'package:aipply/network/http_client.dart' as client;
import 'package:http/http.dart' as http;

import '../utils/constants.dart';
import '../utils/debug_fns.dart';

const kRepoErrorPrepend = 'Something went wrong.';

class ApiRepository {
  Future<List<Question>> generateQuestions({
    required Map<String, dynamic> payload,
  }) async {
    List<Question> questions = [];

    try {
      final response =
          await client.HttpClient.instance
                  .post(
                    resource: AipplyApi.generateQuetion,
                    turnOn: true,
                    data: jsonEncode(payload),
                  )
                  .timeout(Duration(seconds: networkTimeout))
              as http.Response;

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        questions = List<String>.from(
          json['questions'],
        ).map((q) => Question.fromJson(q)).toList();
      }
    } on SocketException {
      printOut(noOrPoorConnection);
    } catch (e, s) {
      printOut('$kRepoErrorPrepend $e\n$s');
    }

    return questions;
  }

  Future<CVDocument> generateCV({required Map<String, dynamic> payload}) async {
    CVDocument document = CVDocument.empty();
    try {
      final response =
          await client.HttpClient.instance
                  .post(
                    resource: AipplyApi.generateCV,
                    turnOn: true,
                    data: jsonEncode(payload),
                  )
                  .timeout(Duration(seconds: networkTimeout))
              as http.Response;

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final cv = json['cv'];
        document = CVDocument(text: cv);
        print('cv document = $cv');
      }
    } on SocketException {
      printOut(noOrPoorConnection);
    } catch (e, s) {
      printOut('$kRepoErrorPrepend $e\n$s');
    }

    return document;
  }

  Future<CoverLetterDocument> generateCoverLetter({
    required Map<String, dynamic> payload,
  }) async {
    CoverLetterDocument document = CoverLetterDocument.empty();
    try {
      final response =
          await client.HttpClient.instance
                  .post(
                    resource: AipplyApi.generateCoverLetter,
                    turnOn: true,
                    data: jsonEncode(payload),
                  )
                  .timeout(Duration(seconds: networkTimeout))
              as http.Response;

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final coverLetter = json['cover'];
        document = CoverLetterDocument(text: coverLetter);

        print('cover letter document = $coverLetter');
      }
    } on SocketException {
      printOut(noOrPoorConnection);
    } catch (e, s) {
      printOut('$kRepoErrorPrepend $e\n$s');
    }

    return document;
  }

  Future<void> generateMetrics() async {}
}
