import 'dart:convert';
import 'package:flutter/foundation.dart';

@immutable
class CVDocument {
  final String text;

  const CVDocument({required this.text});

  /// Factory to create an empty CVDocument object
  factory CVDocument.empty() => const CVDocument(text: '');

  /// Creates a copy of the instance with the given field replaced.
  CVDocument copyWith({String? text}) => CVDocument(text: text ?? this.text);

  /// Deserializes a Map (JSON) into a [CVDocument] instance
  factory CVDocument.fromJson(Map<String, dynamic> json) {
    return CVDocument(
      text: json['cv'] as String? ?? '',
    );
  }

  /// Serializes a [CVDocument] instance into a Map (JSON)
  Map<String, dynamic> toJson() => {'cv': text};

  // --- Static Helpers ---
  static Map<String, dynamic> toMap(CVDocument doc) => doc.toJson();

  static CVDocument? decode(String? data) =>
      data == null ? null : CVDocument.fromJson(json.decode(data));

  static String encode(CVDocument doc) => json.encode(toMap(doc));

  // --- Overrides ---
  @override
  String toString() => 'CVDocument(text: [${text.length} chars])';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is CVDocument && other.text == text);

  @override
  int get hashCode => text.hashCode;
}
