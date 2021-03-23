import 'dart:convert';

import 'dart:typed_data';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:http/http.dart';
import 'package:http/io_client.dart';

// ignore: avoid_classes_with_only_static_members
class HttpCacheManager {
  static const key = 'http_cache_manager';
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(hours: 2),
      maxNrOfCacheObjects: 500,
      repo: JsonCacheInfoRepository(databaseName: key),
      fileService: HttpFileService(),
    ),
  );
}

class CacheHttpClient implements Client {
  final _inner = Client();

  CacheHttpClient();

  @override
  // ignore: type_annotate_public_apis

  Future<Response> get(url, {Map<String, String> headers}) async {
    // final file =
    //     await HttpCacheManager.instance.getSingleFile(url, headers: headers);

    // if (file != null && await file.exists()) {
    //   var res = await file.readAsString();
    //   return Response(res, 200);
    // }
    // return Response(null, 404);

    return _inner.get(url, headers: headers);
  }

  Future<Response> head(url, {Map<String, String> headers}) {
    return _inner.head(url, headers: headers);
  }

  Future<Response> post(url,
      {Map<String, String> headers, body, Encoding encoding}) {
    return _inner.post(url, headers: headers, body: body, encoding: encoding);
  }

  Future<Response> put(url,
      {Map<String, String> headers, body, Encoding encoding}) {
    return _inner.put(url, headers: headers, body: body, encoding: encoding);
  }

  Future<Response> patch(url,
      {Map<String, String> headers, body, Encoding encoding}) {
    return _inner.patch(url, headers: headers, body: body, encoding: encoding);
  }

  Future<Response> delete(url, {Map<String, String> headers}) {
    return _inner.delete(url, headers: headers);
  }

  Future<String> read(url, {Map<String, String> headers}) {
    return _inner.read(url, headers: headers);
  }

  Future<Uint8List> readBytes(url, {Map<String, String> headers}) {
    return _inner.readBytes(url, headers: headers);
  }

  Future<StreamedResponse> send(BaseRequest request) {
    return _inner.send(request);
  }

  void close() {
    return _inner.close();
  }
}
