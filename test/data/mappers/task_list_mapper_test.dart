import 'package:clean_server/data/mappers/task_list_mapper.dart';
import 'package:clean_server/domain/entities/task.dart';
import 'package:clean_server/domain/entities/task_list.dart';
import 'package:test/test.dart';

void main() {
  group('TaskListMapper', () {
    test('toMap should convert TaskList to Map correctly', () {
      final task = Task(id: 't1', taskListId: 'l1', title: 'Task 1');
      final taskList = TaskList(
        id: 'l1',
        title: 'List 1',
        description: 'Desc',
        tasks: [task],
      );

      final map = taskList.toMap();

      expect(map['id'], equals('l1'));
      expect(map['title'], equals('List 1'));
      expect(map['description'], equals('Desc'));
      final tasks = map['tasks'] as List<Map<String, dynamic>>;
      expect(tasks[0]['id'], equals('t1'));
    });

    test('taskListFromMap should convert Map to TaskList correctly', () {
      final map = {
        'id': 'l1',
        'title': 'List 1',
        'description': 'Desc',
        'tasks': [
          {'id': 't1', 'task_list_id': 'l1', 'title': 'Task 1'},
        ],
      };

      final taskList = taskListFromMap(map);

      expect(taskList.id, equals('l1'));
      expect(taskList.title, equals('List 1'));
      expect(taskList.description, equals('Desc'));
      expect(taskList.tasks.length, equals(1));
      expect(taskList.tasks[0].id, equals('t1'));
    });

    test('taskListFromMap should handle null tasks', () {
      final map = {'id': 'l1', 'title': 'List 1'};

      final taskList = taskListFromMap(map);

      expect(taskList.tasks, isEmpty);
      expect(taskList.description, equals(''));
    });
  });
}
