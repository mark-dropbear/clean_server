import 'package:test/test.dart';
import 'package:clean_server/domain/use_cases/create_task.dart';
import 'package:clean_server/data/repositories/in_memory_task_repository.dart';

void main() {
  late InMemoryTaskRepository repository;
  late CreateTask createUseCase;

  setUp(() {
    repository = InMemoryTaskRepository();
    createUseCase = CreateTask(repository);
  });

  group('CreateTask Use Case', () {
    test('should create a task and save it to repository', () async {
      final task = await createUseCase.execute(
        title: 'New Task',
        description: 'New Description',
      );

      expect(task.title, 'New Task');
      expect(task.description, 'New Description');
      expect(task.id, isNotEmpty);

      final saved = await repository.get(task.id);
      expect(saved, equals(task));
    });
  });
}
