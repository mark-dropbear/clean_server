import 'package:meta/meta.dart';
import 'package:slugid/slugid.dart';
import 'report.dart';

/// Represents a browser intervention report.
@immutable
class InterventionReport extends Report {
  /// A unique identifier for the intervention that generated the report.
  final String interventionId;

  /// A human-readable description of the intervention.
  final String message;

  /// The path to the source file where the intervention occurred.
  final String? sourceFile;

  /// The line number in the source file where the intervention occurred.
  final int? lineNumber;

  /// The column number in the source file where the intervention occurred.
  final int? columnNumber;

  /// Creates a new [InterventionReport] instance.
  const InterventionReport({
    required super.id,
    required super.url,
    required super.age,
    required super.receivedAt,
    required this.interventionId,
    required this.message,
    super.userAgent,
    this.sourceFile,
    this.lineNumber,
    this.columnNumber,
  }) : super(type: 'intervention');

  /// Creates an [InterventionReport] from a browser JSON payload.
  factory InterventionReport.fromJson(
    Map<String, dynamic> json, {
    required DateTime receivedAt,
  }) {
    final body = json['body'] as Map<String, dynamic>? ?? {};

    return InterventionReport(
      id: Slugid.nice().toString(),
      url: json['url'] as String? ?? '',
      userAgent: json['user_agent'] as String?,
      age: json['age'] as int? ?? 0,
      receivedAt: receivedAt,
      interventionId: body['id'] as String? ?? '',
      message: body['message'] as String? ?? '',
      sourceFile: body['sourceFile'] as String?,
      lineNumber: body['lineNumber'] as int?,
      columnNumber: body['columnNumber'] as int?,
    );
  }

  /// Creates an [InterventionReport] from a storage [Map].
  factory InterventionReport.fromMap(Map<String, dynamic> map) {
    return InterventionReport(
      id: map['id'] as String,
      url: map['url'] as String,
      userAgent: map['user_agent'] as String?,
      age: map['age'] as int,
      receivedAt: DateTime.parse(map['received_at'] as String),
      interventionId: map['intervention_id'] as String,
      message: map['message'] as String,
      sourceFile: map['source_file'] as String?,
      lineNumber: map['line_number'] as int?,
      columnNumber: map['column_number'] as int?,
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
      'intervention_id': interventionId,
      'message': message,
      'source_file': sourceFile,
      'line_number': lineNumber,
      'column_number': columnNumber,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InterventionReport &&
          super == other &&
          interventionId == other.interventionId &&
          message == other.message &&
          sourceFile == other.sourceFile &&
          lineNumber == other.lineNumber &&
          columnNumber == other.columnNumber;

  @override
  int get hashCode =>
      super.hashCode ^
      interventionId.hashCode ^
      message.hashCode ^
      sourceFile.hashCode ^
      lineNumber.hashCode ^
      columnNumber.hashCode;
}
