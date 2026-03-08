import 'package:test/test.dart';
import 'package:clean_server/domain/entities/task.dart';
import 'package:clean_server/domain/exceptions.dart';

void main() {
  group('Task Entity', () {
    test('should create a valid task', () {
      final task = Task(
        id: '1',
        title: 'Test Task',
        description: 'Description',
      );
      expect(task.id, '1');
      expect(task.title, 'Test Task');
      expect(task.description, 'Description');
      expect(task.isCompleted, false);
    });

    test('should throw InvalidTaskException if id is empty', () {
      expect(
        () => Task(id: '', title: 'Title'),
        throwsA(isA<InvalidTaskException>()),
      );
    });

    test('should throw InvalidTaskException if title is empty', () {
      expect(
        () => Task(id: '1', title: ''),
        throwsA(isA<InvalidTaskException>()),
      );
    });

    test('copyWith should return a new instance with updated values', () {
      final task = Task(id: '1', title: 'Title');
      final updated = task.copyWith(isCompleted: true, description: 'New desc');

      expect(updated.id, '1');
      expect(updated.title, 'Title');
      expect(updated.description, 'New desc');
      expect(updated.isCompleted, true);
    });
  });
}
