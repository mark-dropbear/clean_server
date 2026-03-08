import 'package:clean_server/features/tasks/data/repositories/in_memory_task_repository.dart';
import 'package:clean_server/features/tasks/domain/entities/task.dart';
import 'package:clean_server/features/tasks/domain/use_cases/list_tasks.dart';
import 'package:test/test.dart';

void main() {
  late InMemoryTaskRepository repository;
  late ListTasks listUseCase;

  setUp(() {
    repository = InMemoryTaskRepository();
    listUseCase = ListTasks(repository);
  });

  group('ListTasks Use Case', () {
    test('should return empty list if no tasks exist', () async {
      expect(await listUseCase.execute(), isEmpty);
    });

    test('should return all tasks', () async {
      final t1 = Task(id: '1', taskListId: 'list-1', title: 'Task 1');
      final t2 = Task(id: '2', taskListId: 'list-1', title: 'Task 2');
      await repository.save(t1);
      await repository.save(t2);

      final result = await listUseCase.execute();
      expect(result.length, equals(2));
      expect(result, contains(t1));
      expect(result, contains(t2));
    });
  });
}
