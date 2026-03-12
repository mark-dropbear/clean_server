import 'dart:io';

import 'package:brotli_codec/brotli_codec.dart';
import 'package:shelf/shelf.dart';

/// Middleware that Brotli compresses the response body.
///
/// A response is compressed if:
/// * The request has an 'Accept-Encoding' header that includes 'br'.
/// * The response doesn't already have a 'Content-Encoding' header.
/// * The response body is at least [minimalBrotliContentLength] bytes.
/// * The response's 'Content-Type' is not in the set of [alreadyCompressedContentType].
Middleware brotliCompression({
  int minimalBrotliContentLength = 512,
  int brotliQuality = 4,
  bool addCompressionRatioHeader = true,
  bool addServerTiming = false,
  bool Function(String contentType)? alreadyCompressedContentType,
}) {
  return (Handler innerHandler) {
    return (Request request) async {
      final response = await innerHandler(request);

      if (!canBrotliEncodeResponse(
        request,
        response,
        minimalBrotliContentLength: minimalBrotliContentLength,
        alreadyCompressedContentType: alreadyCompressedContentType,
      )) {
        return response;
      }

      final watch = Stopwatch()..start();

      final bodyBytes = await response.read().fold<List<int>>(
        <int>[],
        (previous, element) => previous..addAll(element),
      );

      final originalLength = bodyBytes.length;

      // Double check length after reading body, just in case.
      if (originalLength < minimalBrotliContentLength) {
        return response.change(body: bodyBytes);
      }

      final encoder = BrotliEncoder(quality: brotliQuality);

      final compressedBytes = encoder.convert(bodyBytes);
      final compressedLength = compressedBytes.length;

      watch.stop();

      final headers = Map<String, String>.from(response.headers);
      headers[HttpHeaders.contentEncodingHeader] = 'br';
      headers[HttpHeaders.contentLengthHeader] = compressedLength.toString();

      // Add Vary: Accept-Encoding to let caches know the response depends on it.
      final existingVary = headers[HttpHeaders.varyHeader];
      if (existingVary == null) {
        headers[HttpHeaders.varyHeader] = HttpHeaders.acceptEncodingHeader;
      } else if (!existingVary.contains(HttpHeaders.acceptEncodingHeader)) {
        headers[HttpHeaders.varyHeader] =
            '$existingVary, ${HttpHeaders.acceptEncodingHeader}';
      }

      if (addCompressionRatioHeader) {
        final ratio = (compressedLength / originalLength).toStringAsFixed(2);
        headers['x-compression-ratio'] =
            '$ratio ($compressedLength/$originalLength)';
      }

      if (addServerTiming) {
        final duration = watch.elapsedMicroseconds / 1000;
        final timing = 'br;dur=$duration';
        const serverTimingHeader = 'server-timing';
        final existingTiming = headers[serverTimingHeader];
        headers[serverTimingHeader] = existingTiming == null
            ? timing
            : '$existingTiming, $timing';
      }

      return response.change(headers: headers, body: compressedBytes);
    };
  };
}

/// Returns true if the [response] can be Brotli encoded for the [request].
bool canBrotliEncodeResponse(
  Request request,
  Response response, {
  required int minimalBrotliContentLength,
  bool Function(String contentType)? alreadyCompressedContentType,
}) {
  final acceptEncoding = request.headers[HttpHeaders.acceptEncodingHeader];
  if (acceptEncoding == null || !acceptEncoding.contains('br')) {
    return false;
  }

  if (response.headers.containsKey(HttpHeaders.contentEncodingHeader)) {
    return false;
  }

  final contentType = response.headers[HttpHeaders.contentTypeHeader];
  if (contentType != null) {
    if (alreadyCompressedContentType != null &&
        alreadyCompressedContentType(contentType)) {
      return false;
    }

    if (_defaultAlreadyCompressedContentType(contentType)) {
      return false;
    }
  }

  final contentLengthHeader = response.headers[HttpHeaders.contentLengthHeader];
  if (contentLengthHeader != null) {
    final contentLength = int.tryParse(contentLengthHeader);
    if (contentLength != null && contentLength < minimalBrotliContentLength) {
      return false;
    }
  }

  return true;
}

bool _defaultAlreadyCompressedContentType(String contentType) {
  final mimeType = contentType.split(';').first.trim().toLowerCase();
  return _alreadyCompressedMimeTypes.contains(mimeType);
}

const _alreadyCompressedMimeTypes = {
  'image/png',
  'image/jpeg',
  'image/gif',
  'image/webp',
  'application/zip',
  'application/x-rar-compressed',
  'application/x-bzip2',
  'application/x-gzip',
  'application/pdf',
  'video/webm',
  'video/mp4',
  'audio/mpeg',
  'audio/wav',
  'font/woff2',
};
