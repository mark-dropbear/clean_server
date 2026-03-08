import 'package:clean_server/data/repositories/in_memory_task_list_repository.dart';
import 'package:clean_server/data/repositories/in_memory_task_repository.dart';
import 'package:clean_server/domain/entities/task.dart';
import 'package:clean_server/domain/entities/task_list.dart';
import 'package:clean_server/domain/use_cases/delete_task_list.dart';
import 'package:test/test.dart';

void main() {
  late InMemoryTaskListRepository taskListRepository;
  late InMemoryTaskRepository taskRepository;
  late DeleteTaskList deleteUseCase;

  setUp(() {
    taskListRepository = InMemoryTaskListRepository();
    taskRepository = InMemoryTaskRepository();
    deleteUseCase = DeleteTaskList(
      taskListRepository: taskListRepository,
      taskRepository: taskRepository,
    );
  });

  group('DeleteTaskList Use Case', () {
    test('should delete task list and associated tasks', () async {
      final taskList = TaskList(id: 'list-1', title: 'Work');
      await taskListRepository.save(taskList);

      final task = Task(id: 'task-1', taskListId: 'list-1', title: 'Task 1');
      await taskRepository.save(task);

      await deleteUseCase.execute('list-1');

      expect(await taskListRepository.getById('list-1'), isNull);
      expect(await taskRepository.getByTaskListId('list-1'), isEmpty);
    });
  });
}
