import 'dart:io';
import 'package:logging/logging.dart';
import 'package:mustache_template/mustache_template.dart';

/// A service that handles loading and rendering of view templates.
class ViewRenderer {
  static final _logger = Logger('ViewRenderer');

  /// The directory containing the main templates.
  final String templateDir;

  /// The directory containing partial templates.
  final String partialsDir;

  final Map<String, Template> _partials = {};
  bool _initialized = false;

  /// Creates a [ViewRenderer].
  ViewRenderer({
    this.templateDir = 'web/templates',
    this.partialsDir = 'web/templates/partials',
  });

  /// Loads and caches all partials from the partials directory.
  Future<void> _initialize() async {
    if (_initialized) return;

    _logger.fine('Initializing partials from $partialsDir');
    final dir = Directory(partialsDir);
    if (await dir.exists()) {
      await for (final file in dir.list()) {
        if (file is File && file.path.endsWith('.mustache')) {
          final name = _getTemplateName(file.path);
          _logger.fine('Loading partial: $name');
          final source = await file.readAsString();
          _partials[name] = Template(source, name: file.path);
        }
      }
    }
    _initialized = true;
  }

  /// Renders a template with the given [data].
  ///
  /// The [templateName] should be the filename without the '.mustache' extension.
  Future<String> render(String templateName, Map<String, dynamic> data) async {
    await _initialize();

    _logger.fine('Rendering template: $templateName');
    final file = File('$templateDir/$templateName.mustache');
    if (!await file.exists()) {
      _logger.warning('Template not found: $templateName');
      throw Exception('Template not found: $templateName');
    }

    try {
      final source = await file.readAsString();
      final template = Template(
        source,
        name: '$templateName.mustache',
        partialResolver: (name) => _partials[name],
      );

      return template.renderString(data);
    } catch (e, st) {
      _logger.severe('Failed to render template: $templateName', e, st);
      rethrow;
    }
  }

  String _getTemplateName(String path) {
    return path.split(Platform.pathSeparator).last.replaceAll('.mustache', '');
  }
}
