library basic_http_interceptor;

import 'dart:convert';
import 'dart:typed_data';

import 'package:basic_http_interceptor/interceptor.dart';
import 'package:http/http.dart';

class InterceptedClient implements Client {
  InterceptedClient._(this._client, this._interceptors);

  static InterceptedClient build(
      {Client? client, List<Interceptor>? interceptors}) {
    return InterceptedClient._(client ?? Client(), interceptors ?? []);
  }

  final Client _client;
  final List<Interceptor> _interceptors;

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    return _notifyOnError(() => _client.send(request));
  }

  @override
  void close() {
    _client.close();
  }

  @override
  Future<Response> delete(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return _notifyOnError(() =>
        _client.delete(url, headers: headers, body: body, encoding: encoding));
  }

  @override
  Future<Response> get(Uri url, {Map<String, String>? headers}) {
    return _notifyOnError(() => _client.get(url, headers: headers));
  }

  @override
  Future<Response> head(Uri url, {Map<String, String>? headers}) {
    return _notifyOnError(() => _client.head(url, headers: headers));
  }

  @override
  Future<Response> patch(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return _notifyOnError(() =>
        _client.patch(url, headers: headers, body: body, encoding: encoding));
  }

  @override
  Future<Response> post(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return _notifyOnError(() =>
        _client.post(url, headers: headers, body: body, encoding: encoding));
  }

  @override
  Future<Response> put(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return _notifyOnError(() =>
        _client.put(url, headers: headers, body: body, encoding: encoding));
  }

  @override
  Future<String> read(Uri url, {Map<String, String>? headers}) {
    return _notifyOnError(() => _client.read(url, headers: headers));
  }

  @override
  Future<Uint8List> readBytes(Uri url, {Map<String, String>? headers}) {
    return _notifyOnError(() => _client.readBytes(url, headers: headers));
  }

  void _notifyInterceptors(Function(Interceptor) callback) {
    for (var i = 0; i < _interceptors.length; i++) {
      callback.call(_interceptors[i]);
    }
  }

  Future<T> _notifyOnError<T>(Future<T> Function() request) {
    try {
      return request.call();
    } on Exception catch (e) {
      _notifyInterceptors((i) => i.onError(e));
      rethrow;
    }
  }
}
