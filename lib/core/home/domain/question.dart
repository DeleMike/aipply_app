import 'dart:convert';
import 'package:flutter/foundation.dart';

@immutable
class Question {
  final List<String> questions;

  const Question({required this.questions});

  /// Factory to create an empty Question object
  factory Question.empty() {
    return const Question(questions: []);
  }

  /// Creates a copy of the instance with the given fields replaced.
  Question copyWith({List<String>? questions}) {
    return Question(questions: questions ?? this.questions);
  }

  /// Deserializes a Map (JSON) into a [Question] instance
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      // Ensures that the JSON list is correctly parsed as List<String>
      questions: List<String>.from(json['questions'] ?? []),
    );
  }

  /// Serializes a [Question] instance into a Map (JSON)
  Map<String, dynamic> toJson() {
    return {'questions': questions};
  }

  // --- Static Helpers ---

  /// Helper to get a Map from a [Question] instance
  static Map<String, dynamic> toMap(Question question) => question.toJson();

  /// Helper to decode a JSON string into a [Question]
  static Question? decode(String? data) =>
      data == null ? null : Question.fromJson(json.decode(data));

  /// Helper to encode a [Question] into a JSON string
  static String encode(Question question) => json.encode(toMap(question));

  // --- Overrides ---

  @override
  String toString() {
    return 'Question(questions: $questions)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    // Use listEquals for deep comparison of lists
    return other is Question && listEquals(other.questions, questions);
  }

  @override
  int get hashCode {
    // A correct hashCode implementation for a list
    return Object.hashAll(questions);
  }
}
