import 'package:http/http.dart' as http;

import '../../utils/debug_fns.dart';
import 'api_config.dart';

/// Create a client connection
///
/// Contains different methods for performing CRUD operations.
/// sometimes, the way the request payload were designed, we are FE Engineers are faced with a challenge
/// of coming up with on-the-fly solutions to mitigate BE engineers weakeness without the app crashing
class HttpClient {
  static final _instance = HttpClient._();

  /// get single instance of the client app connection
  static HttpClient get instance => _instance;

  final api = ApiConfigService();

  /// Create a client connection
  HttpClient._();

  /// get data from resource with microservice specification
  Future get({required String resource, bool turnOn = false}) async {
    final response = await http.get(
      Uri.parse(api.baseUrl() + resource),
      headers: {'Content-Type': 'application/json'},
    );
    _printTokenGetReq(response, turnOn: turnOn);
    return response;
  }

  /// get resource data with token for specific microservice
  Future getResourceWithToken({
    required String resource,
    required String token,
    bool turnOn = false,
  }) async {
    final response = await http.get(
      Uri.parse(api.baseUrl() + resource),
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
    );
    _printTokenGetReq(response, turnOn: turnOn);
    return response;
  }

  /// post a resource data to specific microservice
  Future post({required String resource, data, bool turnOn = false}) async {
    final response = await http.post(
      Uri.parse(api.baseUrl() + resource),
      body: data,
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    );
    _printTokenGetReq(response, turnOn: turnOn);
    return response;
  }

  /// post resource data with token to specific microservice
  Future postResourceWithToken({
    required String resource,
    required String token,
    data,
    bool needsContentType = false,
    bool turnOn = false,
  }) async {
    final response = await http.post(
      Uri.parse(api.baseUrl() + resource),
      body: data,
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
    );
    _printTokenGetReq(response, turnOn: turnOn);
    return response;
  }

  /// update a data resource in specific microservice
  Future updateResourceWithToken({
    required String resource,
    required String token,
    data,
    bool turnOn = false,
  }) async {
    final response = await http.put(
      Uri.parse(api.baseUrl() + resource),
      body: data,
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
    );
    _printTokenGetReq(response, turnOn: turnOn);
    return response;
  }

  /// update a data resource via a patch in specific microservice
  Future updateWithPatchResourceWithToken({
    required String resource,
    required String token,
    data,
    bool turnOn = false,
  }) async {
    final response = await http.patch(
      Uri.parse(api.baseUrl() + resource),
      body: data,
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
    );
    _printTokenGetReq(response, turnOn: turnOn);
    return response;
  }

  /// delete resource data with token from specific microservice
  Future deleteResourceWithToken({
    required String resource,
    required String token,
    data,
    bool turnOn = false,
  }) async {
    final response = await http.delete(
      Uri.parse(api.baseUrl() + resource),
      body: data,
      headers: {'Authorization': 'Bearer $token'},
    );
    _printTokenGetReq(response, turnOn: turnOn);
    return response;
  }

  void _printTokenGetReq(http.Response response, {bool turnOn = false}) {
    if (turnOn) {
      printOut('HttpClient: Request Headers = ${response.request!.headers}');
      printOut('HttpClient: Data = ${response.body}');
      printOut('HttpClient: Real url= ${response.request!.url}');
      printOut('HttpClient: Response status = ${response.statusCode}');
      printOut('HttpClient: Method = ${response.request!.method}');
    }
  }
}
