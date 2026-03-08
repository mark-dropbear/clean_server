import '../entities/report.dart';

/// Repository interface for managing browser reports.
abstract class ReportRepository {
  /// Persists a new [Report].
  Future<void> save(Report report);

  /// Retrieves all stored reports of a specific type.
  Future<List<T>> listByType<T extends Report>(String type);

  /// Retrieves all stored reports.
  Future<List<Report>> listAll();
}
