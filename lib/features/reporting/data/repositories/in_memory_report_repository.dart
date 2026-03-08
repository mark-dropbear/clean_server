import 'package:logging/logging.dart';
import '../../domain/entities/report.dart';
import '../../domain/repositories/report_repository.dart';

/// An in-memory implementation of the [ReportRepository].
class InMemoryReportRepository implements ReportRepository {
  static final _logger = Logger('InMemoryReportRepository');
  final Map<String, Report> _reports = {};

  @override
  Future<void> save(Report report) async {
    _logger.fine('Saving report: ${report.id} (type: ${report.type})');
    _reports[report.id] = report;
  }

  @override
  Future<List<T>> listByType<T extends Report>(String type) async {
    _logger.fine('Listing reports of type: $type');
    return _reports.values
        .where((report) => report.type == type)
        .whereType<T>()
        .toList();
  }

  @override
  Future<List<Report>> listAll() async {
    _logger.fine('Listing all reports');
    return _reports.values.toList();
  }
}
