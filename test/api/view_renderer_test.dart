import 'dart:io';
import 'package:clean_server/api/view_renderer.dart';
import 'package:test/test.dart';

void main() {
  late Directory tempDir;
  late ViewRenderer renderer;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('view_renderer_test');
    final templatesDir = Directory('${tempDir.path}/templates');
    final partialsDir = Directory('${templatesDir.path}/partials');
    await partialsDir.create(recursive: true);

    await File(
      '${templatesDir.path}/home.mustache',
    ).writeAsString('Hello {{name}}! {{> footer}}');
    await File('${partialsDir.path}/footer.mustache').writeAsString('Bye!');

    renderer = ViewRenderer(
      templateDir: templatesDir.path,
      partialsDir: partialsDir.path,
    );
  });

  tearDown(() async {
    await tempDir.delete(recursive: true);
  });

  group('ViewRenderer', () {
    test('render should return rendered template with partials', () async {
      final result = await renderer.render('home', {'name': 'World'});
      expect(result, equals('Hello World! Bye!'));
    });

    test('render should throw exception if template not found', () {
      expect(() => renderer.render('non-existent', {}), throwsException);
    });
  });
}
