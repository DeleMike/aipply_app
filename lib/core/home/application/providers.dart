import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/document_generator_controller.dart';

/// Tracks whether document generation is in progress.
/// Drives the [LoadingOverlay] on the home screen.
final isGeneratingDocumentsProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});

/// Provides the [DocumentGeneratorController] for the home screen.
final documentGeneratorProvider = ChangeNotifierProvider.autoDispose(
  (ref) => DocumentGeneratorController(),
);
