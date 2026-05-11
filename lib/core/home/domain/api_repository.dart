import 'dart:convert';
import 'dart:io';

import 'package:aipply/network/aipply_api.dart';
import 'package:aipply/network/http_client.dart' as client;
import 'package:http/http.dart' as http;

import '../../../utils/constants.dart';
import '../../../utils/debug_fns.dart';
import '../../metrics/domain/metrics.dart';

import 'documents.dart';

const kRepoErrorPrepend = 'Something went wrong.';

class ApiRepository {
  /// Generates both a CV and a cover letter in a single request.
  /// Returns the [Documents] model and an error status string (empty = success).
  Future<(Documents, String)> generateDocuments({
    required Map<String, dynamic> payload,
  }) async {
    Documents documents = Documents.empty();
    String errorStatusMessage = '';

    try {
      final response =
          await client.HttpClient.instance
                  .post(
                    resource: AipplyApi.generateDocuments,
                    turnOn: true,
                    data: jsonEncode(payload),
                  )
                  .timeout(Duration(seconds: networkTimeout))
              as http.Response;

      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // BE returns { "cv": "...", "cover_letter": "..." }
        documents = Documents.fromJson(json);
        printOut('Documents received: $documents');
      } else if (response.statusCode == 429) {
        errorStatusMessage = '429';
      } else {
        errorStatusMessage = '500';
      }
    } on SocketException {
      printOut(noOrPoorConnection);
      errorStatusMessage = '500';
    } catch (e, s) {
      printOut('$kRepoErrorPrepend $e\n$s');
      errorStatusMessage = '500';
    }

    return (documents, errorStatusMessage);
  }

  /// Generates follow-up refinement questions (secondary flow, post-generation).
  Future<(List<String>, String)> generateQuestions({
    required Map<String, dynamic> payload,
  }) async {
    List<String> questions = [];
    String errorStatusMessage = '';

    try {
      final response =
          await client.HttpClient.instance
                  .post(
                    resource: AipplyApi.generateQuestions,
                    turnOn: true,
                    data: jsonEncode(payload),
                  )
                  .timeout(Duration(seconds: networkTimeout))
              as http.Response;

      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        questions = List<String>.from(json['questions'] ?? []);
      } else if (response.statusCode == 429) {
        errorStatusMessage = '429';
      } else {
        errorStatusMessage = '500';
      }
    } on SocketException {
      printOut(noOrPoorConnection);
      errorStatusMessage = '500';
    } catch (e, s) {
      printOut('$kRepoErrorPrepend $e\n$s');
      errorStatusMessage = '500';
    }

    return (questions, errorStatusMessage);
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
