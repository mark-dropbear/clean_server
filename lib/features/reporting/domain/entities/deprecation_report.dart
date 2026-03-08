import 'package:meta/meta.dart';
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
