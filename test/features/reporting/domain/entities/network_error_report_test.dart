import 'package:clean_server/features/reporting/domain/entities/network_error_report.dart';
import 'package:test/test.dart';

void main() {
  group('NetworkErrorReport', () {
    test('should correctly instantiate and preserve fields', () {
      final now = DateTime.now();
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
  });
}
