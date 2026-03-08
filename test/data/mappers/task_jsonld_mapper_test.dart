import 'package:clean_server/data/mappers/task_mapper.dart';
import 'package:clean_server/domain/entities/task.dart';
import 'package:test/test.dart';

void main() {
  group('Task JSON-LD Mapper', () {
    test('toJsonLd should convert active Task correctly', () {
      final task = Task(
        id: 'task-1',
        taskListId: 'list-1',
        title: 'Do Work',
        description: 'Hard work',
      );

      final jsonLd = task.toJsonLd();

      expect(jsonLd['@type'], equals('Action'));
      expect(jsonLd['@id'], equals('task-1'));
      expect(jsonLd['name'], equals('Do Work'));
      expect(jsonLd['description'], equals('Hard work'));
      expect(
        jsonLd['actionStatus'],
        equals('https://schema.org/ActiveActionStatus'),
      );
    });

    test('toJsonLd should convert completed Task correctly', () {
      final task = Task(
        id: 'task-2',
        taskListId: 'list-1',
        title: 'Done Work',
        isCompleted: true,
      );

      final jsonLd = task.toJsonLd();

      expect(
        jsonLd['actionStatus'],
        equals('https://schema.org/CompletedActionStatus'),
      );
    });
  });
}
