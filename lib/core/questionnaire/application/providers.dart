import 'package:aipply/core/questionnaire/data/generate_cover_letter_controller.dart';
import 'package:aipply/core/questionnaire/data/generate_cv_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isGeneratingCVAndCoverLetterProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});

final cvDocumentProvider = ChangeNotifierProvider.autoDispose<GenerateCvController>(
  (ref) => GenerateCvController(),
);

final coverLetterDocumentProvider =
    ChangeNotifierProvider.autoDispose<GenerateCoverLetterController>(
      (ref) => GenerateCoverLetterController(),
    );
