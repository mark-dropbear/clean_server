import 'package:clean_server/data/repositories/in_memory_task_list_repository.dart';
import 'package:clean_server/domain/entities/task_list.dart';
import 'package:clean_server/domain/use_cases/list_task_lists.dart';
import 'package:test/test.dart';

void main() {
  late InMemoryTaskListRepository repository;
  late ListTaskLists listUseCase;

  setUp(() {
    repository = InMemoryTaskListRepository();
    listUseCase = ListTaskLists(repository);
  });

  group('ListTaskLists Use Case', () {
    test('should return empty list if no task lists exist', () async {
      final result = await listUseCase.execute();
      expect(result, isEmpty);
    });

    test('should return all task lists', () async {
      final list1 = TaskList(id: '1', title: 'List 1');
      final list2 = TaskList(id: '2', title: 'List 2');
      await repository.save(list1);
      await repository.save(list2);

      final result = await listUseCase.execute();

      expect(result.length, equals(2));
      expect(result, contains(list1));
      expect(result, contains(list2));
    });
  });
}
