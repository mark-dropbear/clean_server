import 'package:meta/meta.dart';
import 'package:slugid/slugid.dart';
import 'report.dart';

/// Represents a browser renderer crash report.
@immutable
class CrashReport extends Report {
  /// The reason for the crash (e.g., 'oom', 'unresponsive').
  final String? reason;

  /// The stack trace at the time of the crash, if available.
  final String? stack;

  /// Whether the crash occurred in the top-level document.
  final bool? isTopLevel;

  /// Creates a new [CrashReport] instance.
  const CrashReport({
    required super.id,
    required super.url,
    required super.age,
    required super.receivedAt,
    super.userAgent,
    this.reason,
    this.stack,
    this.isTopLevel,
  }) : super(type: 'crash');

  /// Creates a [CrashReport] from a browser JSON payload.
  factory CrashReport.fromJson(
    Map<String, dynamic> json, {
    required DateTime receivedAt,
  }) {
    final body = json['body'] as Map<String, dynamic>? ?? {};

    return CrashReport(
      id: Slugid.nice().toString(),
      url: json['url'] as String? ?? '',
      userAgent: json['user_agent'] as String?,
      age: json['age'] as int? ?? 0,
      receivedAt: receivedAt,
      reason: body['reason'] as String?,
      stack: body['stack'] as String?,
      isTopLevel: body['is_top_level'] as bool?,
    );
  }

  /// Creates a [CrashReport] from a storage [Map].
  factory CrashReport.fromMap(Map<String, dynamic> map) {
    return CrashReport(
      id: map['id'] as String,
      url: map['url'] as String,
      userAgent: map['user_agent'] as String?,
      age: map['age'] as int,
      receivedAt: DateTime.parse(map['received_at'] as String),
      reason: map['reason'] as String?,
      stack: map['stack'] as String?,
      isTopLevel: map['is_top_level'] as bool?,
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
      'reason': reason,
      'stack': stack,
      'is_top_level': isTopLevel,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CrashReport &&
          super == other &&
          reason == other.reason &&
          stack == other.stack &&
          isTopLevel == other.isTopLevel;

  @override
  int get hashCode =>
      super.hashCode ^ reason.hashCode ^ stack.hashCode ^ isTopLevel.hashCode;
}
