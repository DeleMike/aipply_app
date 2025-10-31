import 'dart:convert';
import 'dart:io';

import 'package:aipply/core/home/domain/question.dart';
import 'package:aipply/core/questionnaire/domain/cover_letter_document.dart';
import 'package:aipply/core/questionnaire/domain/cv_document.dart';
import 'package:aipply/network/aipply_api.dart';
import 'package:aipply/network/http_client.dart' as client;
import 'package:http/http.dart' as http;

import '../core/metrics/domain/metrics.dart';
import '../utils/constants.dart';
import '../utils/debug_fns.dart';

const kRepoErrorPrepend = 'Something went wrong.';

class ApiRepository {
  Future<(List<Question>, String)> generateQuestions({
    required Map<String, dynamic> payload,
  }) async {
    List<Question> questions = [];
    String errorStatusMessage = "";

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
      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        questions = List<String>.from(
          json['questions'],
        ).map((q) => Question.fromJson(q)).toList();
      } else if (response.statusCode == 429) {
        errorStatusMessage = "429";
      } else {
        errorStatusMessage = "500";
      }
    } on SocketException {
      printOut(noOrPoorConnection);
    } catch (e, s) {
      printOut('$kRepoErrorPrepend $e\n$s');
    }

    return (questions, errorStatusMessage);
  }

  Future<(CVDocument, String)> generateCV({required Map<String, dynamic> payload}) async {
    CVDocument document = CVDocument.empty();
    String errorStatusMessage = "";
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
      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final cv = json['cv'];
        document = CVDocument(text: cv);
        print('cv document = $cv');
      } else if (response.statusCode == 429) {
        errorStatusMessage = "429";
      } else {
        errorStatusMessage = "500";
      }
    } on SocketException {
      printOut(noOrPoorConnection);
    } catch (e, s) {
      printOut('$kRepoErrorPrepend $e\n$s');
    }

    return (document, errorStatusMessage);
  }

  Future<(CoverLetterDocument, String)> generateCoverLetter({
    required Map<String, dynamic> payload,
  }) async {
    CoverLetterDocument document = CoverLetterDocument.empty();
    String errorStatusMessage = "";

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
      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final coverLetter = json['cover'];
        document = CoverLetterDocument(text: coverLetter);

        print('cover letter document = $coverLetter');
      } else if (response.statusCode == 429) {
        errorStatusMessage = "429";
      } else {
        errorStatusMessage = "500";
      }
    } on SocketException {
      printOut(noOrPoorConnection);
    } catch (e, s) {
      printOut('$kRepoErrorPrepend $e\n$s');
    }

    return (document, errorStatusMessage);
  }

  Future<Metrics?> generateMetrics() async {
    Metrics? metrics;
    try {
      final response =
          await client.HttpClient.instance
                  .get(resource: AipplyApi.metrics, turnOn: true)
                  .timeout(Duration(seconds: networkTimeout))
              as http.Response;

      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        metrics = Metrics.fromJson(json);
      }
      printOut('Metrics = $metrics');
    } on SocketException {
      printOut(noOrPoorConnection);
    } catch (e, s) {
      printOut('$kRepoErrorPrepend $e\n$s');
    }

    return metrics;
  }
}
