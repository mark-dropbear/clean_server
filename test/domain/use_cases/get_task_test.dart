import 'package:clean_server/data/repositories/in_memory_task_repository.dart';
import 'package:clean_server/domain/entities/task.dart';
import 'package:clean_server/domain/use_cases/get_task.dart';
import 'package:test/test.dart';

void main() {
  late InMemoryTaskRepository repository;
  late GetTask getUseCase;

  setUp(() {
    repository = InMemoryTaskRepository();
    getUseCase = GetTask(repository);
  });

  group('GetTask Use Case', () {
    test('should return null if task does not exist', () async {
      expect(await getUseCase.execute('non-existent'), isNull);
    });

    test('should return task if it exists', () async {
      final task = Task(id: '1', taskListId: 'list-1', title: 'Task 1');
      await repository.save(task);

      final result = await getUseCase.execute('1');
      expect(result, equals(task));
    });
  });
}
