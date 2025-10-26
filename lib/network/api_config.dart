import 'package:dio/dio.dart';

import '../../utils/debug_fns.dart';

/// Configuration Service for Dio
class ApiConfigService {
  Dio dio = Dio();

  static const devBaseUrl = 'localhost:5050/api/v1/';

  /// Configuration Service for Dio
  ApiConfigService();

  /// make a request for specific microservice
  Dio $Request() {
    dio.options.baseUrl = baseUrl();
    return dio;
  }

  /// Get base URL for specific microservice
  String baseUrl() {
    return devBaseUrl;
  }

  /// Set Headers
  Map<String, dynamic> setHeaders() {
    Map<String, dynamic> header = {};
    printOut("user-header $header");
    return header;
  }
}
