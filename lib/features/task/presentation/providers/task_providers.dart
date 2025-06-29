import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/task_model.dart';
import '../../domain/repositories/task_repository.dart';
import '../../data/repositories/task_repository_impl.dart';
part 'task_providers.g.dart';

enum TaskFilter { all, active, completed }

enum TaskSort { dueDate, createdAt }

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final taskBox = ref.watch(taskBoxProvider);
  return TaskRepositoryImpl(taskBox: taskBox);
});


@riverpod
Box<Task> taskBox(TaskBoxRef ref) {
  throw UnimplementedError('Should be overridden in main.dart');
}

@riverpod
class TaskNotifier extends _$TaskNotifier {
  @override
  Future<List<Task>> build() async {
    return _fetchTasks();
  }

  Future<List<Task>> _fetchTasks() async {
    final repository = ref.read(taskRepositoryProvider);
    return repository.getAllTasks();
  }

  Future<void> addTask(Task task) async {
    final repository = ref.read(taskRepositoryProvider);
    await repository.addTask(task);
    ref.invalidateSelf();
  }

  Future<void> updateTask(Task task) async {
    final repository = ref.read(taskRepositoryProvider);
    await repository.updateTask(task);
    ref.invalidateSelf();
  }

  Future<void> deleteTask(String id) async {
    final repository = ref.read(taskRepositoryProvider);
    await repository.deleteTask(id);
    ref.invalidateSelf();
  }

  Future<void> toggleTaskCompletion(String id) async {
    final repository = ref.read(taskRepositoryProvider);
    await repository.toggleTaskCompletion(id);
    ref.invalidateSelf();
  }
}

@riverpod
class TaskFilterNotifier extends _$TaskFilterNotifier {
  @override
  TaskFilter build() {
    return TaskFilter.all;
  }

  void setFilter(TaskFilter filter) {
    state = filter;
  }
}

@riverpod
class TaskSortNotifier extends _$TaskSortNotifier {
  @override
  TaskSort build() {
    return TaskSort.dueDate;
  }

  void setSort(TaskSort sort) {
    state = sort;
  }
}

@riverpod
Future<List<Task>> filteredSortedTasks(FilteredSortedTasksRef ref) async {
  final filter = ref.watch(taskFilterNotifierProvider);
  final sort = ref.watch(taskSortNotifierProvider);
  final tasksAsync = ref.watch(taskNotifierProvider);
  
  return tasksAsync.when(
    data: (tasks) {
      // Apply filter
      List<Task> filteredTasks = tasks;
      switch (filter) {
        case TaskFilter.active:
          filteredTasks = tasks.where((task) => !task.isCompleted).toList();
          break;
        case TaskFilter.completed:
          filteredTasks = tasks.where((task) => task.isCompleted).toList();
          break;
        default:
          filteredTasks = tasks;
      }

      filteredTasks.sort((a, b) {
        switch (sort) {
          case TaskSort.dueDate:
            if (a.dueDate == null) return 1;
            if (b.dueDate == null) return -1;
            return a.dueDate!.compareTo(b.dueDate!);
          case TaskSort.createdAt:
            return b.createdAt.compareTo(a.createdAt); // Newest first
        }
      });

      return filteredTasks;
    },
    loading: () => [],
    error: (_, __) => [],
  );
}