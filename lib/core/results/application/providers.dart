import 'package:flutter_riverpod/flutter_riverpod.dart';

final isDownloadingDocumentProvider = StateProvider.autoDispose<bool>((ref) => false);
