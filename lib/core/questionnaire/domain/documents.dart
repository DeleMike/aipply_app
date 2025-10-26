import 'package:freezed_annotation/freezed_annotation.dart';

part 'documents.freezed.dart';

@immutable
@freezed
/// Documents data model
class Documents with _$Documents {
  final String cvText;
  final String coverLetterText;

  const Documents({required this.cvText, required this.coverLetterText});
}
