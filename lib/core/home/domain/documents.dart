import 'dart:convert';
import 'package:flutter/foundation.dart';

@immutable
class Documents {
  final String cvText;
  final String coverLetterText;

  const Documents({required this.cvText, required this.coverLetterText});

  /// Factory to create an empty Documents object
  factory Documents.empty() {
    return const Documents(cvText: '', coverLetterText: '');
  }

  /// Creates a copy of the instance with the given fields replaced.
  Documents copyWith({String? cvText, String? coverLetterText}) {
    return Documents(
      cvText: cvText ?? this.cvText,
      coverLetterText: coverLetterText ?? this.coverLetterText,
    );
  }

  /// Deserializes a Map (JSON) into a [Documents] instance
  /// Note the use of your custom JSON keys.
  factory Documents.fromJson(Map<String, dynamic> json) {
    return Documents(
      cvText: json['cv'] as String? ?? '',
      coverLetterText: json['cover_letter'] as String? ?? '',
    );
  }

  /// Serializes a [Documents] instance into a Map (JSON)
  /// Note the use of your custom JSON keys.
  Map<String, dynamic> toJson() {
    return {'cv': cvText, 'cover_letter': coverLetterText};
  }

  // --- Static Helpers ---

  /// Helper to get a Map from a [Documents] instance
  static Map<String, dynamic> toMap(Documents documents) => documents.toJson();

  /// Helper to decode a JSON string into a [Documents]
  static Documents? decode(String? data) =>
      data == null ? null : Documents.fromJson(json.decode(data));

  /// Helper to encode a [Documents] into a JSON string
  static String encode(Documents documents) => json.encode(toMap(documents));

  // --- Overrides ---

  @override
  String toString() {
    return 'Documents(cvText: [${cvText.length} chars], coverLetterText: [${coverLetterText.length} chars])';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Documents &&
        other.cvText == cvText &&
        other.coverLetterText == coverLetterText;
  }

  @override
  int get hashCode {
    // Use Object.hash for multiple fields
    return Object.hash(cvText, coverLetterText);
  }
}
