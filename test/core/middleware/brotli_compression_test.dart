import 'dart:io';

import 'package:brotli_codec/brotli_codec.dart';
import 'package:clean_server/core/middleware/brotli_compression.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  group('brotliCompression', () {
    test('does not compress if accept-encoding does not include br', () async {
      final handler = const Pipeline()
          .addMiddleware(brotliCompression())
          .addHandler((request) {
        return Response.ok('a' * 1000, headers: {'content-type': 'text/plain'});
      });

      final response = await handler(Request('GET', Uri.parse('http://localhost/')));
      expect(response.headers[HttpHeaders.contentEncodingHeader], isNull);
      expect(await response.readAsString(), 'a' * 1000);
    });

    test('does not compress if response already has content-encoding', () async {
      final handler = const Pipeline()
          .addMiddleware(brotliCompression())
          .addHandler((request) {
        return Response.ok('a' * 1000, headers: {
          HttpHeaders.contentEncodingHeader: 'gzip',
          HttpHeaders.contentTypeHeader: 'text/plain',
        });
      });

      final response = await handler(Request('GET', Uri.parse('http://localhost/'),
          headers: {HttpHeaders.acceptEncodingHeader: 'br'}));
      expect(response.headers[HttpHeaders.contentEncodingHeader], 'gzip');
      expect(await response.readAsString(), 'a' * 1000);
    });

    test('does not compress if body is too small', () async {
      final handler = const Pipeline()
          .addMiddleware(brotliCompression(minimalBrotliContentLength: 512))
          .addHandler((request) {
        return Response.ok('a' * 100, headers: {'content-type': 'text/plain'});
      });

      final response = await handler(Request('GET', Uri.parse('http://localhost/'),
          headers: {HttpHeaders.acceptEncodingHeader: 'br'}));
      expect(response.headers[HttpHeaders.contentEncodingHeader], isNull);
      expect(await response.readAsString(), 'a' * 100);
    });

    test('compresses if criteria are met', () async {
      final content = 'a' * 1000;
      final handler = const Pipeline()
          .addMiddleware(brotliCompression())
          .addHandler((request) {
        return Response.ok(content, headers: {'content-type': 'text/plain'});
      });

      final response = await handler(Request('GET', Uri.parse('http://localhost/'),
          headers: {HttpHeaders.acceptEncodingHeader: 'br'}));

      expect(response.headers[HttpHeaders.contentEncodingHeader], 'br');
      expect(response.headers[HttpHeaders.contentLengthHeader], isNotNull);
      
      final bodyBytes = await response.read().fold<List<int>>(
            <int>[],
            (previous, element) => previous..addAll(element),
          );
      
      final decompressed = const BrotliDecoder().convert(bodyBytes);
      expect(String.fromCharCodes(decompressed), content);
    });

    test('adds x-compression-ratio header by default', () async {
      final handler = const Pipeline()
          .addMiddleware(brotliCompression())
          .addHandler((request) {
        return Response.ok('a' * 1000, headers: {'content-type': 'text/plain'});
      });

      final response = await handler(Request('GET', Uri.parse('http://localhost/'),
          headers: {HttpHeaders.acceptEncodingHeader: 'br'}));

      expect(response.headers['x-compression-ratio'], isNotNull);
    });

    test('adds server-timing header when enabled', () async {
      final handler = const Pipeline()
          .addMiddleware(brotliCompression(addServerTiming: true))
          .addHandler((request) {
        return Response.ok('a' * 1000, headers: {'content-type': 'text/plain'});
      });

      final response = await handler(Request('GET', Uri.parse('http://localhost/'),
          headers: {HttpHeaders.acceptEncodingHeader: 'br'}));

      expect(response.headers['server-timing'], contains('br;dur='));
    });

    test('skips already compressed mime types', () async {
      final handler = const Pipeline()
          .addMiddleware(brotliCompression())
          .addHandler((request) {
        return Response.ok('a' * 1000, headers: {'content-type': 'image/png'});
      });

      final response = await handler(Request('GET', Uri.parse('http://localhost/'),
          headers: {HttpHeaders.acceptEncodingHeader: 'br'}));

      expect(response.headers[HttpHeaders.contentEncodingHeader], isNull);
    });

    test('respects custom alreadyCompressedContentType callback', () async {
      final handler = const Pipeline()
          .addMiddleware(brotliCompression(
            alreadyCompressedContentType: (type) => type == 'text/custom',
          ))
          .addHandler((request) {
        return Response.ok('a' * 1000, headers: {'content-type': 'text/custom'});
      });

      final response = await handler(Request('GET', Uri.parse('http://localhost/'),
          headers: {HttpHeaders.acceptEncodingHeader: 'br'}));

      expect(response.headers[HttpHeaders.contentEncodingHeader], isNull);
    });
  });
}
