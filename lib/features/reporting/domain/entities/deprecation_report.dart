import 'package:meta/meta.dart';
import 'package:slugid/slugid.dart';
import 'report.dart';

/// Represents a browser deprecation report.
@immutable
class DeprecationReport extends Report {
  /// A unique identifier for the deprecated feature or API.
  final String featureId;

  /// A human-readable description of the deprecation.
  final String message;

  /// The path to the source file where the deprecated feature was used.
  final String? sourceFile;

  /// The line number in the source file where the deprecation occurred.
  final int? lineNumber;

  /// The column number in the source file where the deprecation occurred.
  final int? columnNumber;

  /// A string representation of a Date indicating when the feature is expected to be removed.
  final DateTime? anticipatedRemoval;

  /// Creates a new [DeprecationReport] instance.
  const DeprecationReport({
    required super.id,
    required super.url,
    required super.age,
    required super.receivedAt,
    required this.featureId,
    required this.message,
    super.userAgent,
    this.sourceFile,
    this.lineNumber,
    this.columnNumber,
    this.anticipatedRemoval,
  }) : super(type: 'deprecation');

  /// Creates a [DeprecationReport] from a browser JSON payload.
  factory DeprecationReport.fromJson(
    Map<String, dynamic> json, {
    required DateTime receivedAt,
  }) {
    final body = json['body'] as Map<String, dynamic>? ?? {};

    return DeprecationReport(
      id: Slugid.nice().toString(),
      url: json['url'] as String? ?? '',
      userAgent: json['user_agent'] as String?,
      age: json['age'] as int? ?? 0,
      receivedAt: receivedAt,
      featureId: body['id'] as String? ?? '',
      message: body['message'] as String? ?? '',
      sourceFile: body['sourceFile'] as String?,
      lineNumber: body['lineNumber'] as int?,
      columnNumber: body['columnNumber'] as int?,
      anticipatedRemoval: _parseDateTime(body['anticipatedRemoval'] as String?),
    );
  }

  /// Creates a [DeprecationReport] from a storage [Map].
  factory DeprecationReport.fromMap(Map<String, dynamic> map) {
    return DeprecationReport(
      id: map['id'] as String,
      url: map['url'] as String,
      userAgent: map['user_agent'] as String?,
      age: map['age'] as int,
      receivedAt: DateTime.parse(map['received_at'] as String),
      featureId: map['feature_id'] as String,
      message: map['message'] as String,
      sourceFile: map['source_file'] as String?,
      lineNumber: map['line_number'] as int?,
      columnNumber: map['column_number'] as int?,
      anticipatedRemoval: map['anticipated_removal'] != null
          ? DateTime.parse(map['anticipated_removal'] as String)
          : null,
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
      'feature_id': featureId,
      'message': message,
      'source_file': sourceFile,
      'line_number': lineNumber,
      'column_number': columnNumber,
      'anticipated_removal': anticipatedRemoval?.toIso8601String(),
    };
  }

  static DateTime? _parseDateTime(String? value) {
    if (value == null) return null;
    return DateTime.tryParse(value);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeprecationReport &&
          super == other &&
          featureId == other.featureId &&
          message == other.message &&
          sourceFile == other.sourceFile &&
          lineNumber == other.lineNumber &&
          columnNumber == other.columnNumber &&
          anticipatedRemoval == other.anticipatedRemoval;

  @override
  int get hashCode =>
      super.hashCode ^
      featureId.hashCode ^
      message.hashCode ^
      sourceFile.hashCode ^
      lineNumber.hashCode ^
      columnNumber.hashCode ^
      anticipatedRemoval.hashCode;
}
