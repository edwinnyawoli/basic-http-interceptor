import 'package:basic_http_interceptor/interceptor.dart';
import 'package:http/src/response.dart';

class TestInterceptor implements Interceptor {
  final List<dynamic> errors = [];

  @override
  Future<void> onError(dynamic error) async {
    errors.add(error);
  }

  @override
  Future<void> onResponse(Response response) async {}
}
