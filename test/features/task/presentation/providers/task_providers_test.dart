import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pocket_tasks/features/task/domain/repositories/task_repository.dart';
import 'package:pocket_tasks/features/task/presentation/providers/task_providers.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late MockTaskRepository mockRepository;
  late ProviderContainer container;
  
  setUp(() {
    mockRepository = MockTaskRepository();
    container = ProviderContainer(
      overrides: [
        taskRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
  });
  
  tearDown(() {
    container.dispose();
  });
  
  group('TaskFilterNotifier', () {
    test('should have TaskFilter.all as initial state', () {
      final filter = container.read(taskFilterNotifierProvider);
      expect(filter, TaskFilter.all);
    });
    
    test('should update filter when setFilter is called', () {
      container.read(taskFilterNotifierProvider.notifier).setFilter(TaskFilter.completed);
      final filter = container.read(taskFilterNotifierProvider);
      expect(filter, TaskFilter.completed);
    });
  });
  
  group('TaskSortNotifier', () {
    test('should have TaskSort.dueDate as initial state', () {
      final sort = container.read(taskSortNotifierProvider);
      expect(sort, TaskSort.dueDate);
    });
    
    test('should update sort when setSort is called', () {
      container.read(taskSortNotifierProvider.notifier).setSort(TaskSort.createdAt);
      final sort = container.read(taskSortNotifierProvider);
      expect(sort, TaskSort.createdAt);
    });
  });
}