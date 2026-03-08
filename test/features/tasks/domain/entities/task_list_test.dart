import 'package:clean_server/core/exceptions.dart';
import 'package:clean_server/features/tasks/domain/entities/task.dart';
import 'package:clean_server/features/tasks/domain/entities/task_list.dart';
import 'package:test/test.dart';

void main() {
  group('TaskList Entity', () {
    test('should create a valid TaskList', () {
      final taskList = TaskList(
        id: 'list-1',
        title: 'Work',
        description: 'Work related tasks',
      );

      expect(taskList.id, equals('list-1'));
      expect(taskList.title, equals('Work'));
      expect(taskList.description, equals('Work related tasks'));
      expect(taskList.tasks, isEmpty);
    });

    test('should throw InvalidTaskException if id is empty', () {
      expect(
        () => TaskList(id: '', title: 'Work'),
        throwsA(isA<InvalidTaskException>()),
      );
    });

    test('should throw InvalidTaskException if title is empty', () {
      expect(
        () => TaskList(id: 'list-1', title: ''),
        throwsA(isA<InvalidTaskException>()),
      );
    });

    test('should copyWith updated fields', () {
      final taskList = TaskList(id: 'list-1', title: 'Work');
      final task = Task(id: 'task-1', taskListId: 'list-1', title: 'Task 1');

      final updated = taskList.copyWith(
        title: 'New Title',
        description: 'New Description',
        tasks: [task],
      );

      expect(updated.id, equals(taskList.id));
      expect(updated.title, equals('New Title'));
      expect(updated.description, equals('New Description'));
      expect(updated.tasks, contains(task));
    });

    test('equality and hashcode', () {
      final t1 = TaskList(id: '1', title: 'A');
      final t2 = TaskList(id: '1', title: 'A');
      final t3 = TaskList(id: '2', title: 'A');

      expect(t1, equals(t2));
      expect(t1.hashCode, equals(t2.hashCode));
      expect(t1, isNot(equals(t3)));
    });
  });
}
