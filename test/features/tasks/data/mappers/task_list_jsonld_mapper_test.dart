import 'package:clean_server/features/tasks/data/mappers/task_list_mapper.dart';
import 'package:clean_server/features/tasks/domain/entities/task.dart';
import 'package:clean_server/features/tasks/domain/entities/task_list.dart';
import 'package:test/test.dart';

void main() {
  group('TaskList JSON-LD Mapper', () {
    test('toJsonLd should convert TaskList correctly', () {
      final task = Task(id: 't1', taskListId: 'l1', title: 'Task 1');
      final taskList = TaskList(
        id: 'l1',
        title: 'Work',
        description: 'My Work',
        tasks: [task],
      );

      final jsonLd = taskList.toJsonLd();

      expect(jsonLd['@context'], equals('https://schema.org'));
      expect(jsonLd['@type'], equals('ItemList'));
      expect(jsonLd['@id'], equals('l1'));
      expect(jsonLd['name'], equals('Work'));
      expect(jsonLd['description'], equals('My Work'));

      final elements = jsonLd['itemListElement'] as List;
      expect(elements.length, equals(1));

      final listItem = elements[0] as Map<String, dynamic>;
      expect(listItem['@type'], equals('ListItem'));

      final action = listItem['item'] as Map<String, dynamic>;
      expect(action['@type'], equals('Action'));
      expect(action['@id'], equals('t1'));
    });
  });
}
