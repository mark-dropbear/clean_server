import 'package:clean_server/core/exceptions.dart';
import 'package:clean_server/features/tasks/data/repositories/in_memory_task_repository.dart';
import 'package:clean_server/features/tasks/domain/entities/task.dart';
import 'package:clean_server/features/tasks/domain/use_cases/update_task.dart';
import 'package:test/test.dart';

void main() {
  late InMemoryTaskRepository repository;
  late UpdateTask updateUseCase;

  setUp(() {
    repository = InMemoryTaskRepository();
    updateUseCase = UpdateTask(repository);
  });

  group('UpdateTask Use Case', () {
    test('should throw TaskNotFoundException if task does not exist', () {
      expect(
        () => updateUseCase.execute('non-existent', title: 'New'),
        throwsA(isA<TaskNotFoundException>()),
      );
    });

    test('should update and save task', () async {
      final task = Task(id: '1', taskListId: 'list-1', title: 'Old Title');
      await repository.save(task);

      final updated = await updateUseCase.execute(
        '1',
        title: 'New Title',
        description: 'New Desc',
        isCompleted: true,
      );

      expect(updated.title, equals('New Title'));
      expect(updated.description, equals('New Desc'));
      expect(updated.isCompleted, isTrue);

      final saved = await repository.getById('1');
      expect(saved, equals(updated));
    });
  });
}
