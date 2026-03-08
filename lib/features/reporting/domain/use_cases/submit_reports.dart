import '../../data/mappers/report_mapper.dart';
import '../entities/report.dart';
import '../repositories/report_repository.dart';

/// Use case for submitting a batch of browser reports.
class SubmitReports {
  /// The repository for storing reports.
  final ReportRepository reportRepository;

  /// Creates a [SubmitReports] instance.
  SubmitReports(this.reportRepository);

  /// Processes and saves a list of report maps using pattern matching.
  ///
  /// Each map in [reportMaps] is expected to be a single report object
  /// from the Reporting API JSON array.
  Future<List<Report>> execute(
    List<Map<String, dynamic>> reportMaps,
  ) async {
    final reports = <Report>[];
    final receivedAt = DateTime.now().toUtc();

    for (final map in reportMaps) {
      final type = map['type'] as String?;
      final report = switch (type) {
        'deprecation' => DeprecationReportMapper.fromReportingApi(
            map,
            receivedAt: receivedAt,
          ),
        // Add other report types here as they are supported
        _ => null,
      };

      if (report != null) {
        await reportRepository.save(report);
        reports.add(report);
      }
    }

    return reports;
  }
}
