import 'package:clean_server/data/mappers/task_mapper.dart';
import 'package:clean_server/domain/entities/task.dart';
import 'package:test/test.dart';

void main() {
  group('TaskMapper', () {
    test('toMap should convert Task to Map correctly', () {
      final task = Task(
        id: '1',
        taskListId: 'list-1',
        title: 'Title',
        description: 'Desc',
        isCompleted: true,
      );

      final map = task.toMap();

      expect(map['id'], equals('1'));
      expect(map['task_list_id'], equals('list-1'));
      expect(map['title'], equals('Title'));
      expect(map['description'], equals('Desc'));
      expect(map['is_completed'], isTrue);
    });

    test('taskFromMap should convert Map to Task correctly', () {
      final map = {
        'id': '1',
        'task_list_id': 'list-1',
        'title': 'Title',
        'description': 'Desc',
        'is_completed': true,
      };

      final task = taskFromMap(map);

      expect(task.id, equals('1'));
      expect(task.taskListId, equals('list-1'));
      expect(task.title, equals('Title'));
      expect(task.description, equals('Desc'));
      expect(task.isCompleted, isTrue);
    });

    test('taskFromMap should handle null description and is_completed', () {
      final map = {'id': '1', 'task_list_id': 'list-1', 'title': 'Title'};

      final task = taskFromMap(map);

      expect(task.description, equals(''));
      expect(task.isCompleted, isFalse);
    });
  });
}
