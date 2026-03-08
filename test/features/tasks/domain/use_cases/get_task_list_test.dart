import 'package:clean_server/features/tasks/data/repositories/in_memory_task_list_repository.dart';
import 'package:clean_server/features/tasks/data/repositories/in_memory_task_repository.dart';
import 'package:clean_server/features/tasks/domain/entities/task.dart';
import 'package:clean_server/features/tasks/domain/entities/task_list.dart';
import 'package:clean_server/features/tasks/domain/use_cases/get_task_list.dart';
import 'package:test/test.dart';

void main() {
  late InMemoryTaskListRepository taskListRepository;
  late InMemoryTaskRepository taskRepository;
  late GetTaskList getUseCase;

  setUp(() {
    taskListRepository = InMemoryTaskListRepository();
    taskRepository = InMemoryTaskRepository();
    getUseCase = GetTaskList(
      taskListRepository: taskListRepository,
      taskRepository: taskRepository,
    );
  });

  group('GetTaskList Use Case', () {
    test('should return null if list does not exist', () async {
      final result = await getUseCase.execute('non-existent');
      expect(result, isNull);
    });

    test('should return task list with tasks', () async {
      final taskList = TaskList(id: 'list-1', title: 'Work');
      await taskListRepository.save(taskList);

      final task1 = Task(id: 'task-1', taskListId: 'list-1', title: 'Task 1');
      final task2 = Task(id: 'task-2', taskListId: 'list-1', title: 'Task 2');
      await taskRepository.save(task1);
      await taskRepository.save(task2);

      final result = await getUseCase.execute('list-1');

      expect(result, isNotNull);
      expect(result?.id, equals('list-1'));
      expect(result?.tasks.length, equals(2));
      expect(result?.tasks, contains(task1));
      expect(result?.tasks, contains(task2));
    });
  });
}
