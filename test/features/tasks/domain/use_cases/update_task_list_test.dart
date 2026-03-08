import 'package:clean_server/core/exceptions.dart';
import 'package:clean_server/features/tasks/data/repositories/in_memory_task_list_repository.dart';
import 'package:clean_server/features/tasks/domain/entities/task_list.dart';
import 'package:clean_server/features/tasks/domain/use_cases/update_task_list.dart';
import 'package:test/test.dart';

void main() {
  late InMemoryTaskListRepository repository;
  late UpdateTaskList updateUseCase;

  setUp(() {
    repository = InMemoryTaskListRepository();
    updateUseCase = UpdateTaskList(repository);
  });

  group('UpdateTaskList Use Case', () {
    test('should throw TaskListNotFoundException if list does not exist', () {
      expect(
        () => updateUseCase.execute('non-existent', title: 'New'),
        throwsA(isA<TaskListNotFoundException>()),
      );
    });

    test('should update and save task list', () async {
      final list = TaskList(id: '1', title: 'Old Title', description: 'Old');
      await repository.save(list);

      final updated = await updateUseCase.execute(
        '1',
        title: 'New Title',
        description: 'New',
      );

      expect(updated.title, equals('New Title'));
      expect(updated.description, equals('New'));

      final saved = await repository.getById('1');
      expect(saved, equals(updated));
    });
  });
}
