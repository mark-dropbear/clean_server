import 'package:slugid/slugid.dart';
import '../entities/deprecation_report.dart';
import '../repositories/report_repository.dart';

/// Use case for submitting a batch of deprecation reports.
class SubmitDeprecationReports {
  /// The repository for storing reports.
  final ReportRepository reportRepository;

  /// Creates a [SubmitDeprecationReports] instance.
  SubmitDeprecationReports(this.reportRepository);

  /// Processes and saves a list of deprecation report maps.
  ///
  /// Each map in [reportMaps] is expected to be a single report object
  /// from the Reporting API JSON array.
  Future<List<DeprecationReport>> execute(
    List<Map<String, dynamic>> reportMaps,
  ) async {
    final reports = <DeprecationReport>[];
    final receivedAt = DateTime.now().toUtc();

    for (final map in reportMaps) {
      if (map['type'] != 'deprecation') continue;

      final body = map['body'] as Map<String, dynamic>? ?? {};

      final report = DeprecationReport(
        id: Slugid.nice().toString(),
        url: (map['url'] as String?) ?? '',
        userAgent: map['user_agent'] as String?,
        age: (map['age'] as int?) ?? 0,
        receivedAt: receivedAt,
        featureId: (body['id'] as String?) ?? '',
        message: (body['message'] as String?) ?? '',
        sourceFile: body['sourceFile'] as String?,
        lineNumber: body['lineNumber'] as int?,
        columnNumber: body['columnNumber'] as int?,
        anticipatedRemoval: _parseDateTime(
          body['anticipatedRemoval'] as String?,
        ),
      );

      await reportRepository.save(report);
      reports.add(report);
    }

    return reports;
  }

  DateTime? _parseDateTime(String? value) {
    if (value == null) return null;
    return DateTime.tryParse(value);
  }
}
