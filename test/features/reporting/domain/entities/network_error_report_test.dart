import 'package:clean_server/features/reporting/domain/entities/network_error_report.dart';
import 'package:test/test.dart';

void main() {
  group('NetworkErrorReport', () {
    final now = DateTime.now();

    test('should correctly instantiate and preserve fields', () {
      final report = NetworkErrorReport(
        id: '1',
        url: 'https://example.com/page',
        age: 100,
        receivedAt: now,
        errorType: 'http.error',
        phase: 'application',
        elapsedTime: 338,
        statusCode: 400,
        serverIp: '192.0.2.172',
        protocol: 'http/1.1',
        method: 'POST',
        referrer: 'https://example.com/prev',
        samplingFraction: 1.0,
        failedUrl: 'https://example.com/api',
      );

      expect(report.id, '1');
      expect(report.type, 'network-error');
      expect(report.url, 'https://example.com/page');
      expect(report.age, 100);
      expect(report.receivedAt, now);
      expect(report.errorType, 'http.error');
      expect(report.phase, 'application');
      expect(report.elapsedTime, 338);
      expect(report.statusCode, 400);
      expect(report.serverIp, '192.0.2.172');
      expect(report.protocol, 'http/1.1');
      expect(report.method, 'POST');
      expect(report.referrer, 'https://example.com/prev');
      expect(report.samplingFraction, 1.0);
      expect(report.failedUrl, 'https://example.com/api');
    });

    test('should create from browser JSON (fromJson)', () {
      final json = {
        'type': 'network-error',
        'url': 'https://example.com/page',
        'age': 100,
        'body': {
          'type': 'http.error',
          'phase': 'application',
          'elapsed_time': 338,
          'status_code': 400,
          'server_ip': '192.0.2.172',
          'protocol': 'http/1.1',
          'method': 'POST',
          'referrer': 'https://example.com/prev',
          'sampling_fraction': 1.0,
          'url': 'https://example.com/api',
        },
      };

      final report = NetworkErrorReport.fromJson(json, receivedAt: now);

      expect(report.type, 'network-error');
      expect(report.errorType, 'http.error');
      expect(report.phase, 'application');
      expect(report.elapsedTime, 338);
      expect(report.statusCode, 400);
      expect(report.serverIp, '192.0.2.172');
      expect(report.protocol, 'http/1.1');
      expect(report.method, 'POST');
      expect(report.referrer, 'https://example.com/prev');
      expect(report.samplingFraction, 1.0);
      expect(report.failedUrl, 'https://example.com/api');
      expect(report.receivedAt, now);
    });

    test('should support serialization (toMap/fromMap)', () {
      final original = NetworkErrorReport(
        id: '1',
        url: 'https://example.com/page',
        age: 100,
        receivedAt: DateTime.parse(now.toIso8601String()),
        errorType: 'http.error',
        phase: 'application',
        elapsedTime: 338,
        statusCode: 400,
        serverIp: '192.0.2.172',
        protocol: 'http/1.1',
        method: 'POST',
        referrer: 'https://example.com/prev',
        samplingFraction: 1.0,
        failedUrl: 'https://example.com/api',
      );

      final map = original.toMap();
      final fromMap = NetworkErrorReport.fromMap(map);

      expect(fromMap, equals(original));
      expect(fromMap.errorType, 'http.error');
    });

    test('should support equality', () {
      final r1 = NetworkErrorReport(
        id: '1',
        url: 'x',
        age: 1,
        receivedAt: now,
        errorType: 'e',
      );
      final r2 = NetworkErrorReport(
        id: '1',
        url: 'x',
        age: 1,
        receivedAt: now,
        errorType: 'e',
      );
      final r3 = NetworkErrorReport(
        id: '2',
        url: 'x',
        age: 1,
        receivedAt: now,
        errorType: 'e',
      );

      expect(r1, equals(r2));
      expect(r1, isNot(equals(r3)));
      expect(r1.hashCode, equals(r2.hashCode));
    });
  });
}
