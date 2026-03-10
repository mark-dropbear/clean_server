import '../entities/report.dart';
import '../repositories/report_repository.dart';

/// Use case for submitting a batch of browser reports.
class SubmitReports {
  /// The repository for storing reports.
  final ReportRepository reportRepository;

  /// Creates a [SubmitReports] instance.
  SubmitReports(this.reportRepository);

  /// Processes and saves a list of reports.
  Future<void> execute(List<Report> reports) async {
    for (final report in reports) {
      await reportRepository.save(report);
    }
  }
}
