import 'package:clean_server/data/repositories/in_memory_task_repository.dart';
import 'package:clean_server/domain/entities/task.dart';
import 'package:test/test.dart';

void main() {
  late InMemoryTaskRepository repository;

  setUp(() {
    repository = InMemoryTaskRepository();
  });

  group('InMemoryTaskRepository', () {
    test('save and getById', () async {
      final task = Task(id: '1', taskListId: 'l1', title: 'T1');
      await repository.save(task);

      final result = await repository.getById('1');
      expect(result, equals(task));
    });

    test('delete', () async {
      final task = Task(id: '1', taskListId: 'l1', title: 'T1');
      await repository.save(task);
      await repository.delete('1');

      expect(await repository.getById('1'), isNull);
    });

    test('deleteByTaskListId', () async {
      await repository.save(Task(id: '1', taskListId: 'l1', title: 'T1'));
      await repository.save(Task(id: '2', taskListId: 'l1', title: 'T2'));
      await repository.save(Task(id: '3', taskListId: 'l2', title: 'T3'));

      await repository.deleteByTaskListId('l1');

      final tasks = await repository.list();
      expect(tasks.length, equals(1));
      expect(tasks[0].id, equals('3'));
    });

    test('list', () async {
      final t1 = Task(id: '1', taskListId: 'l1', title: 'T1');
      final t2 = Task(id: '2', taskListId: 'l1', title: 'T2');
      await repository.save(t1);
      await repository.save(t2);

      final result = await repository.list();
      expect(result.length, equals(2));
      expect(result, contains(t1));
      expect(result, contains(t2));
    });

    test('getByTaskListId', () async {
      final t1 = Task(id: '1', taskListId: 'l1', title: 'T1');
      final t2 = Task(id: '2', taskListId: 'l2', title: 'T2');
      await repository.save(t1);
      await repository.save(t2);

      final result = await repository.getByTaskListId('l1');
      expect(result.length, equals(1));
      expect(result[0], equals(t1));
    });

    test('update', () async {
      final task = Task(id: '1', taskListId: 'l1', title: 'Old');
      await repository.save(task);

      final updated = task.copyWith(title: 'New');
      await repository.update(updated);

      final result = await repository.getById('1');
      expect(result?.title, equals('New'));
    });
  });
}
