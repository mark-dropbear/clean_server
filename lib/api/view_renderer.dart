import 'dart:io';
import 'package:mustache_template/mustache_template.dart';

/// A service that handles loading and rendering of view templates.
class ViewRenderer {
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

    final dir = Directory(partialsDir);
    if (await dir.exists()) {
      await for (final file in dir.list()) {
        if (file is File && file.path.endsWith('.mustache')) {
          final name = _getTemplateName(file.path);
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

    final file = File('$templateDir/$templateName.mustache');
    if (!await file.exists()) {
      throw Exception('Template not found: $templateName');
    }

    final source = await file.readAsString();
    final template = Template(
      source,
      name: '$templateName.mustache',
      partialResolver: (name) => _partials[name],
    );

    return template.renderString(data);
  }

  String _getTemplateName(String path) {
    return path.split(Platform.pathSeparator).last.replaceAll('.mustache', '');
  }
}
