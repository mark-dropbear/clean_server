import 'package:clean_server/data/repositories/in_memory_task_repository.dart';
import 'package:clean_server/domain/entities/task.dart';
import 'package:clean_server/domain/use_cases/delete_task.dart';
import 'package:test/test.dart';

void main() {
  late InMemoryTaskRepository repository;
  late DeleteTask deleteUseCase;

  setUp(() {
    repository = InMemoryTaskRepository();
    deleteUseCase = DeleteTask(repository);
  });

  group('DeleteTask Use Case', () {
    test('should delete task from repository', () async {
      final task = Task(id: '1', taskListId: 'list-1', title: 'Task 1');
      await repository.save(task);

      await deleteUseCase.execute('1');

      expect(await repository.getById('1'), isNull);
    });
  });
}
