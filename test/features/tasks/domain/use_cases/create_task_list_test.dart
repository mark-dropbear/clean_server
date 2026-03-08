import 'package:clean_server/features/tasks/data/repositories/in_memory_task_list_repository.dart';
import 'package:clean_server/features/tasks/domain/use_cases/create_task_list.dart';
import 'package:test/test.dart';

void main() {
  late InMemoryTaskListRepository repository;
  late CreateTaskList createUseCase;

  setUp(() {
    repository = InMemoryTaskListRepository();
    createUseCase = CreateTaskList(repository);
  });

  group('CreateTaskList Use Case', () {
    test('should create a task list and save it to repository', () async {
      final taskList = await createUseCase.execute(
        title: 'New List',
        description: 'Description',
      );

      expect(taskList.title, equals('New List'));
      expect(taskList.description, equals('Description'));
      expect(taskList.id, isNotEmpty);

      final savedList = await repository.getById(taskList.id);
      expect(savedList, equals(taskList));
    });
  });
}
