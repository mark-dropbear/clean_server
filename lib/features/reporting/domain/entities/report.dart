import 'package:meta/meta.dart';

/// Base class for all browser reports.
@immutable
abstract class Report {
  /// The unique identifier for this report instance.
  final String id;

  /// The report type (e.g., 'deprecation', 'csp-violation').
  final String type;

  /// The URL of the document that generated the report.
  final String url;

  /// The User-Agent of the browser that generated the report.
  final String? userAgent;

  /// The number of milliseconds between report generation and delivery.
  final int age;

  /// The timestamp when the report was received by the server.
  final DateTime receivedAt;

  /// Creates a new [Report] instance.
  const Report({
    required this.id,
    required this.type,
    required this.url,
    required this.age,
    required this.receivedAt,
    this.userAgent,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Report &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type &&
          url == other.url &&
          userAgent == other.userAgent &&
          age == other.age &&
          receivedAt == other.receivedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      type.hashCode ^
      url.hashCode ^
      userAgent.hashCode ^
      age.hashCode ^
      receivedAt.hashCode;
}
