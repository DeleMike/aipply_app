import 'dart:convert';
import 'package:flutter/foundation.dart';

@immutable
class CoverLetterDocument {
  final String text;

  const CoverLetterDocument({required this.text});

  /// Factory to create an empty CoverLetterDocument object
  factory CoverLetterDocument.empty() => const CoverLetterDocument(text: '');

  /// Creates a copy of the instance with the given field replaced.
  CoverLetterDocument copyWith({String? text}) =>
      CoverLetterDocument(text: text ?? this.text);

  /// Deserializes a Map (JSON) into a [CoverLetterDocument] instance
  factory CoverLetterDocument.fromJson(Map<String, dynamic> json) {
    return CoverLetterDocument(text: json['cover_letter'] as String? ?? '');
  }

  /// Serializes a [CoverLetterDocument] instance into a Map (JSON)
  Map<String, dynamic> toJson() => {'cover_letter': text};

  // --- Static Helpers ---
  static Map<String, dynamic> toMap(CoverLetterDocument doc) => doc.toJson();

  static CoverLetterDocument? decode(String? data) =>
      data == null ? null : CoverLetterDocument.fromJson(json.decode(data));

  static String encode(CoverLetterDocument doc) => json.encode(toMap(doc));

  // --- Overrides ---
  @override
  String toString() => 'CoverLetterDocument(text: [${text.length} chars])';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is CoverLetterDocument && other.text == text);

  @override
  int get hashCode => text.hashCode;
}
