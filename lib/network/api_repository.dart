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
                  .get(resource: AipplyApi.generateQuetion, turnOn: true)
                  .timeout(Duration(seconds: networkTimeout))
              as http.Response;

      if (response.statusCode == 200) {
        final json = await Isolate.run(() => jsonDecode(response.body));
        final data = json['questions'];

        questions = data.map((e) => Question.fromJson(e)).toList();
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
