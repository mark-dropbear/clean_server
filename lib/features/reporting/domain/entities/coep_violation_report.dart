import 'package:meta/meta.dart';
import 'package:slugid/slugid.dart';
import 'report.dart';

/// Represents a Cross-Origin Embedder Policy (COEP) violation report.
@immutable
class CoepViolationReport extends Report {
  /// The cause of the violation (e.g., 'corp', 'navigation', 'worker initialization').
  final String? violationType;

  /// The URL of the resource that was blocked.
  final String? blockedUrl;

  /// The type of resource that was blocked (e.g., 'image', 'script').
  final String? destination;

  /// Whether the violation was enforced ('enforce') or just reported ('reporting').
  final String? disposition;

  /// Creates a new [CoepViolationReport] instance.
  const CoepViolationReport({
    required super.id,
    required super.url,
    required super.age,
    required super.receivedAt,
    super.userAgent,
    this.violationType,
    this.blockedUrl,
    this.destination,
    this.disposition,
  }) : super(type: 'coep');

  /// Creates a [CoepViolationReport] from a browser JSON payload.
  factory CoepViolationReport.fromJson(
    Map<String, dynamic> json, {
    required DateTime receivedAt,
  }) {
    final body = json['body'] as Map<String, dynamic>? ?? {};

    return CoepViolationReport(
      id: Slugid.nice().toString(),
      url: json['url'] as String? ?? '',
      userAgent: json['user_agent'] as String?,
      age: json['age'] as int? ?? 0,
      receivedAt: receivedAt,
      violationType: body['type'] as String?,
      blockedUrl: body['blockedURL'] as String?,
      destination: body['destination'] as String?,
      disposition: body['disposition'] as String?,
    );
  }

  /// Creates a [CoepViolationReport] from a storage [Map].
  factory CoepViolationReport.fromMap(Map<String, dynamic> map) {
    return CoepViolationReport(
      id: map['id'] as String,
      url: map['url'] as String,
      userAgent: map['user_agent'] as String?,
      age: map['age'] as int,
      receivedAt: DateTime.parse(map['received_at'] as String),
      violationType: map['violation_type'] as String?,
      blockedUrl: map['blocked_url'] as String?,
      destination: map['destination'] as String?,
      disposition: map['disposition'] as String?,
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
      'violation_type': violationType,
      'blocked_url': blockedUrl,
      'destination': destination,
      'disposition': disposition,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoepViolationReport &&
          super == other &&
          violationType == other.violationType &&
          blockedUrl == other.blockedUrl &&
          destination == other.destination &&
          disposition == other.disposition;

  @override
  int get hashCode =>
      super.hashCode ^
      violationType.hashCode ^
      blockedUrl.hashCode ^
      destination.hashCode ^
      disposition.hashCode;
}
