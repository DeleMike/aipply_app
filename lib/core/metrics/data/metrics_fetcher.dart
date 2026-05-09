import 'package:aipply/core/home/domain/api_repository.dart';

import '../domain/metrics.dart';

Future<Metrics?> fetchMetrics() async {
  final apiRepo = ApiRepository();
  final metrics = await apiRepo.generateMetrics();
  return metrics;
}
