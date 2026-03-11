import 'package:meta/meta.dart';
import 'package:slugid/slugid.dart';
import 'report.dart';

/// Represents a Cross-Origin Opener Policy (COOP) violation report.
@immutable
class CoopViolationReport extends Report {
  /// Whether the violation was enforced ('enforce') or just reported ('reporting').
  final String? disposition;

  /// The COOP policy of the document that triggered the report.
  final String? effectivePolicy;

  /// The type of violation.
  final String? violation;

  /// The name of the property or method that was accessed.
  final String? property;

  /// The URL of the other document involved in the violation.
  final String? otherDocumentUrl;

  /// Creates a new [CoopViolationReport] instance.
  const CoopViolationReport({
    required super.id,
    required super.url,
    required super.age,
    required super.receivedAt,
    super.userAgent,
    this.disposition,
    this.effectivePolicy,
    this.violation,
    this.property,
    this.otherDocumentUrl,
  }) : super(type: 'coop');

  /// Creates a [CoopViolationReport] from a browser JSON payload.
  factory CoopViolationReport.fromJson(
    Map<String, dynamic> json, {
    required DateTime receivedAt,
  }) {
    final body = json['body'] as Map<String, dynamic>? ?? {};

    return CoopViolationReport(
      id: Slugid.nice().toString(),
      url: json['url'] as String? ?? '',
      userAgent: json['user_agent'] as String?,
      age: json['age'] as int? ?? 0,
      receivedAt: receivedAt,
      disposition: body['disposition'] as String?,
      effectivePolicy: body['effectivePolicy'] as String?,
      violation: body['violation'] as String?,
      property: body['property'] as String?,
      otherDocumentUrl: body['otherDocumentURL'] as String?,
    );
  }

  /// Creates a [CoopViolationReport] from a storage [Map].
  factory CoopViolationReport.fromMap(Map<String, dynamic> map) {
    return CoopViolationReport(
      id: map['id'] as String,
      url: map['url'] as String,
      userAgent: map['user_agent'] as String?,
      age: map['age'] as int,
      receivedAt: DateTime.parse(map['received_at'] as String),
      disposition: map['disposition'] as String?,
      effectivePolicy: map['effective_policy'] as String?,
      violation: map['violation'] as String?,
      property: map['property'] as String?,
      otherDocumentUrl: map['other_document_url'] as String?,
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
      'disposition': disposition,
      'effective_policy': effectivePolicy,
      'violation': violation,
      'property': property,
      'other_document_url': otherDocumentUrl,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoopViolationReport &&
          super == other &&
          disposition == other.disposition &&
          effectivePolicy == other.effectivePolicy &&
          violation == other.violation &&
          property == other.property &&
          otherDocumentUrl == other.otherDocumentUrl;

  @override
  int get hashCode =>
      super.hashCode ^
      disposition.hashCode ^
      effectivePolicy.hashCode ^
      violation.hashCode ^
      property.hashCode ^
      otherDocumentUrl.hashCode;
}
