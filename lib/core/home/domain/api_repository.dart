import 'dart:convert';
import 'dart:io';

import 'package:aipply/core/home/domain/question.dart';
import 'package:aipply/core/home/domain/documents.dart';

import 'package:aipply/network/aipply_api.dart';
import 'package:aipply/network/http_client.dart' as client;
import 'package:http/http.dart' as http;

import '../../metrics/domain/metrics.dart';
import '../../../utils/constants.dart';
import '../../../utils/debug_fns.dart';
import 'cover_letter_document.dart';
import 'cv_document.dart';

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

  Future<(CVDocument, CoverLetterDocument, String)> generateDocuments({
    required Map<String, dynamic> payload,
  }) async {
    String errorStatusMessage = "";
    CVDocument cv = CVDocument.empty();
    CoverLetterDocument coverLetter = CoverLetterDocument.empty();

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
        final _cv = json['cv'];
        cv = CVDocument(text: _cv);
        print('cv document = $cv');

        // generate cover letter
        final _cover_letter = json['cover_letter'];
        coverLetter = CoverLetterDocument(text: _cover_letter);
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

    return (cv, coverLetter, errorStatusMessage);
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
