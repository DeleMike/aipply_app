import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/metrics_fetcher.dart';
import '../domain/metrics.dart';

final metricsStreamProvider = StreamProvider<Metrics?>((ref) {
  final controller = StreamController<Metrics?>();
  Timer? timer;

  // This function fetches our metrics and adds it to the stream
  Future<void> fetchAndAdd() async {
    try {
      final metrics = await fetchMetrics();
      if (!controller.isClosed) {
        controller.add(metrics);
      }
    } catch (e, stack) {
      if (!controller.isClosed) {
        controller.addError(e, stack);
      }
    }
  }

  fetchAndAdd();
  timer = Timer.periodic(const Duration(seconds: 10), (_) {
    fetchAndAdd();
  });

  ref.onDispose(() {
    timer?.cancel();
    controller.close();
  });

  return controller.stream;
});
