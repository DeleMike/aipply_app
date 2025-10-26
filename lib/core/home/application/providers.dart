import 'package:aipply/core/home/data/question_generator_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isGeneratingQuestionsProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});

final questionGeneratorController = ChangeNotifierProvider.autoDispose(
  (ref) => QuestionGeneratorController(),
);
