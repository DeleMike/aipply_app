import 'package:freezed_annotation/freezed_annotation.dart';


part 'question.freezed.dart';

@immutable
@freezed
/// Question data model
class Question with _$Question{
  final String question;
  const Question({required this.question});
}
