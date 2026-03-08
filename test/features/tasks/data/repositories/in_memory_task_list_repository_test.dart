import 'package:clean_server/features/tasks/data/repositories/in_memory_task_list_repository.dart';
import 'package:clean_server/features/tasks/domain/entities/task_list.dart';
import 'package:test/test.dart';

void main() {
  late InMemoryTaskListRepository repository;

  setUp(() {
    repository = InMemoryTaskListRepository();
  });

  group('InMemoryTaskListRepository', () {
    test('save and getById', () async {
      final list = TaskList(id: '1', title: 'L1');
      await repository.save(list);

      final result = await repository.getById('1');
      expect(result, equals(list));
    });

    test('delete', () async {
      final list = TaskList(id: '1', title: 'L1');
      await repository.save(list);
      await repository.delete('1');

      expect(await repository.getById('1'), isNull);
    });

    test('list', () async {
      final l1 = TaskList(id: '1', title: 'L1');
      final l2 = TaskList(id: '2', title: 'L2');
      await repository.save(l1);
      await repository.save(l2);

      final result = await repository.list();
      expect(result.length, equals(2));
      expect(result, contains(l1));
      expect(result, contains(l2));
    });

    test('update', () async {
      final list = TaskList(id: '1', title: 'Old');
      await repository.save(list);

      final updated = list.copyWith(title: 'New');
      await repository.update(updated);

      final result = await repository.getById('1');
      expect(result?.title, equals('New'));
    });
  });
}
