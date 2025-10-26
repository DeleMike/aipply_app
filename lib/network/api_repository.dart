import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:aipply/core/home/domain/question.dart';
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

  Future<void> generateDocuments() async {}

  Future<void> generateMetrics() async {}
}
