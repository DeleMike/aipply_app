import 'package:flutter_riverpod/flutter_riverpod.dart';

final isGeneratingQuestionsProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});
