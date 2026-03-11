import 'package:meta/meta.dart';
import 'package:slugid/slugid.dart';
import 'report.dart';

/// Represents a Subresource Integrity (SRI) violation report.
@immutable
class IntegrityViolationReport extends Report {
  /// The URL of the resource that was blocked.
  final String? blockedUrl;

  /// The URL of the document where the violation occurred.
  final String? documentUrl;

  /// The type of resource that was blocked (e.g., 'script').
  final String? destination;

  /// Whether the violation was only logged (report-only).
  final bool? reportOnly;

  /// Creates a new [IntegrityViolationReport] instance.
  const IntegrityViolationReport({
    required super.id,
    required super.url,
    required super.age,
    required super.receivedAt,
    super.userAgent,
    this.blockedUrl,
    this.documentUrl,
    this.destination,
    this.reportOnly,
  }) : super(type: 'integrity-violation');

  /// Creates an [IntegrityViolationReport] from a browser JSON payload.
  factory IntegrityViolationReport.fromJson(
    Map<String, dynamic> json, {
    required DateTime receivedAt,
  }) {
    final body = json['body'] as Map<String, dynamic>? ?? {};

    return IntegrityViolationReport(
      id: Slugid.nice().toString(),
      url: json['url'] as String? ?? '',
      userAgent: json['user_agent'] as String?,
      age: json['age'] as int? ?? 0,
      receivedAt: receivedAt,
      blockedUrl: body['blockedURL'] as String?,
      documentUrl: body['documentURL'] as String?,
      destination: body['destination'] as String?,
      reportOnly: body['reportOnly'] as bool?,
    );
  }

  /// Creates an [IntegrityViolationReport] from a storage [Map].
  factory IntegrityViolationReport.fromMap(Map<String, dynamic> map) {
    return IntegrityViolationReport(
      id: map['id'] as String,
      url: map['url'] as String,
      userAgent: map['user_agent'] as String?,
      age: map['age'] as int,
      receivedAt: DateTime.parse(map['received_at'] as String),
      blockedUrl: map['blocked_url'] as String?,
      documentUrl: map['document_url'] as String?,
      destination: map['destination'] as String?,
      reportOnly: map['report_only'] as bool?,
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
      'blocked_url': blockedUrl,
      'document_url': documentUrl,
      'destination': destination,
      'report_only': reportOnly,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IntegrityViolationReport &&
          super == other &&
          blockedUrl == other.blockedUrl &&
          documentUrl == other.documentUrl &&
          destination == other.destination &&
          reportOnly == other.reportOnly;

  @override
  int get hashCode =>
      super.hashCode ^
      blockedUrl.hashCode ^
      documentUrl.hashCode ^
      destination.hashCode ^
      reportOnly.hashCode;
}
