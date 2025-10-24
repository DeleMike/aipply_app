import 'package:flutter_riverpod/flutter_riverpod.dart';

final isGeneratingCVAndCoverLetterProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});
