import 'package:basic_http_interceptor/client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'interceptor_test.mocks.dart';
import 'test_interceptor.dart';

@GenerateMocks([Client])
void main() {
  test('adds one to input values', () async {
    final MockClient mockClient = MockClient();
    final TestInterceptor interceptor = TestInterceptor();
    final client = InterceptedClient.build(
      client: mockClient,
      interceptors: [interceptor],
    );

    when(mockClient.read(any)).thenThrow(new Exception('Fake excpetion'));

    try {
      await client.read(Uri.parse('https://www.google.com'));
    } catch (e) {
      print(e.toString());
    }
    expect(interceptor.errors.length, 1);
  });
}
