import 'package:meta/meta.dart';
import 'package:slugid/slugid.dart';
import 'report.dart';

/// Represents a Network Error Logging (NEL) report.
@immutable
class NetworkErrorReport extends Report {
  /// The specific error category (e.g., 'dns.name_not_resolved', 'http.error').
  final String? errorType;

  /// The network phase where the error occurred ('dns', 'connection', 'application').
  final String? phase;

  /// The milliseconds elapsed between the start of the fetch and the error.
  final int? elapsedTime;

  /// The HTTP status code received (0 if no response was received).
  final int? statusCode;

  /// The IP address of the server.
  final String? serverIp;

  /// The network protocol used (e.g., 'http/1.1').
  final String? protocol;

  /// The HTTP method used.
  final String? method;

  /// The referrer of the request.
  final String? referrer;

  /// The sampling rate used when the report was generated.
  final double? samplingFraction;

  /// The URL of the request that failed.
  final String? failedUrl;

  /// Creates a new [NetworkErrorReport] instance.
  const NetworkErrorReport({
    required super.id,
    required super.url,
    required super.age,
    required super.receivedAt,
    super.userAgent,
    this.errorType,
    this.phase,
    this.elapsedTime,
    this.statusCode,
    this.serverIp,
    this.protocol,
    this.method,
    this.referrer,
    this.samplingFraction,
    this.failedUrl,
  }) : super(type: 'network-error');

  /// Creates a [NetworkErrorReport] from a browser JSON payload.
  factory NetworkErrorReport.fromJson(
    Map<String, dynamic> json, {
    required DateTime receivedAt,
  }) {
    final body = json['body'] as Map<String, dynamic>? ?? {};

    return NetworkErrorReport(
      id: Slugid.nice().toString(),
      url: json['url'] as String? ?? '',
      userAgent: json['user_agent'] as String?,
      age: json['age'] as int? ?? 0,
      receivedAt: receivedAt,
      errorType: body['type'] as String?,
      phase: body['phase'] as String?,
      elapsedTime: body['elapsed_time'] as int?,
      statusCode: body['status_code'] as int?,
      serverIp: body['server_ip'] as String?,
      protocol: body['protocol'] as String?,
      method: body['method'] as String?,
      referrer: body['referrer'] as String?,
      samplingFraction: (body['sampling_fraction'] as num?)?.toDouble(),
      failedUrl: body['url'] as String?,
    );
  }

  /// Creates a [NetworkErrorReport] from a storage [Map].
  factory NetworkErrorReport.fromMap(Map<String, dynamic> map) {
    return NetworkErrorReport(
      id: map['id'] as String,
      url: map['url'] as String,
      userAgent: map['user_agent'] as String?,
      age: map['age'] as int,
      receivedAt: DateTime.parse(map['received_at'] as String),
      errorType: map['error_type'] as String?,
      phase: map['phase'] as String?,
      elapsedTime: map['elapsed_time'] as int?,
      statusCode: map['status_code'] as int?,
      serverIp: map['server_ip'] as String?,
      protocol: map['protocol'] as String?,
      method: map['method'] as String?,
      referrer: map['referrer'] as String?,
      samplingFraction: (map['sampling_fraction'] as num?)?.toDouble(),
      failedUrl: map['failed_url'] as String?,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'url': url,
      'user_agent': userAgent,
      'age': age,
      'received_at': receivedAt.toIso8601String(),
      'error_type': errorType,
      'phase': phase,
      'elapsed_time': elapsedTime,
      'status_code': statusCode,
      'server_ip': serverIp,
      'protocol': protocol,
      'method': method,
      'referrer': referrer,
      'sampling_fraction': samplingFraction,
      'failed_url': failedUrl,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NetworkErrorReport &&
          super == other &&
          errorType == other.errorType &&
          phase == other.phase &&
          elapsedTime == other.elapsedTime &&
          statusCode == other.statusCode &&
          serverIp == other.serverIp &&
          protocol == other.protocol &&
          method == other.method &&
          referrer == other.referrer &&
          samplingFraction == other.samplingFraction &&
          failedUrl == other.failedUrl;

  @override
  int get hashCode =>
      super.hashCode ^
      errorType.hashCode ^
      phase.hashCode ^
      elapsedTime.hashCode ^
      statusCode.hashCode ^
      serverIp.hashCode ^
      protocol.hashCode ^
      method.hashCode ^
      referrer.hashCode ^
      samplingFraction.hashCode ^
      failedUrl.hashCode;
}
