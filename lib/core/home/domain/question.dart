import 'dart:convert';
import 'package:flutter/foundation.dart';

@immutable
class Question {
  final String question;

  const Question({required this.question});

  /// Creates an empty Question instance.
  factory Question.empty() => const Question(question: '');

  /// Creates a copy of the instance with the given fields replaced.
  Question copyWith({String? question}) {
    return Question(question: question ?? this.question);
  }

  /// Creates a [Question] from a JSON value (string or map).
  factory Question.fromJson(dynamic json) {
    if (json is String) {
      return Question(question: json);
    } else if (json is Map<String, dynamic>) {
      return Question(question: json['question'] ?? '');
    } else {
      throw ArgumentError('Invalid JSON for Question: $json');
    }
  }

  /// Converts the Question to JSON.
  Map<String, dynamic> toJson() => {'question': question};

  /// Encodes a Question into a JSON string.
  static String encode(Question question) => json.encode(question.toJson());

  /// Decodes a JSON string into a Question.
  static Question? decode(String? data) =>
      data == null ? null : Question.fromJson(json.decode(data));

  @override
  String toString() => question;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Question && other.question == question);

  @override
  int get hashCode => question.hashCode;
}
