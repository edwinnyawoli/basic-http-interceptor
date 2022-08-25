import 'package:http/http.dart';

abstract class Interceptor {
  // Currently not being used
  Future<void> onResponse(Response response);

  Future<void> onError(dynamic error);
}
