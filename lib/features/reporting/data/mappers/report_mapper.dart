import 'package:slugid/slugid.dart';
import '../../domain/entities/deprecation_report.dart';

/// Extension on [DeprecationReport] to provide mapping logic.
extension DeprecationReportMapper on DeprecationReport {
  /// Converts this [DeprecationReport] to a [Map].
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

  /// Creates a [DeprecationReport] from the official browser Reporting API payload.
  static DeprecationReport fromReportingApi(
    Map<String, dynamic> map, {
    required DateTime receivedAt,
  }) {
    final body = map['body'] as Map<String, dynamic>? ?? {};

    return DeprecationReport(
      id: Slugid.nice().toString(),
      url: map['url'] as String? ?? '',
      userAgent: map['user_agent'] as String?,
      age: map['age'] as int? ?? 0,
      receivedAt: receivedAt,
      featureId: body['id'] as String? ?? '',
      message: body['message'] as String? ?? '',
      sourceFile: body['sourceFile'] as String?,
      lineNumber: body['lineNumber'] as int?,
      columnNumber: body['columnNumber'] as int?,
      anticipatedRemoval: _parseDateTime(body['anticipatedRemoval'] as String?),
    );
  }

  static DateTime? _parseDateTime(String? value) {
    if (value == null) return null;
    return DateTime.tryParse(value);
  }
}

/// Creates a [DeprecationReport] from an internal storage [Map].
DeprecationReport deprecationReportFromMap(Map<String, dynamic> map) {
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
