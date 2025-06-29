import 'package:hive/hive.dart';
import '../../domain/models/task_model.dart';
import '../../domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final Box<Task> taskBox;

  TaskRepositoryImpl({required this.taskBox});

  @override
  Future<List<Task>> getAllTasks() async {
    return taskBox.values.toList();
  }

  @override
  Future<void> addTask(Task task) async {
    await taskBox.put(task.id, task);
  }

  @override
  Future<void> updateTask(Task task) async {
    await taskBox.put(task.id, task);
  }

  @override
  Future<void> deleteTask(String id) async {
    await taskBox.delete(id);
  }

  @override
  Future<void> toggleTaskCompletion(String id) async {
    final task = taskBox.get(id);
    if (task != null) {
      final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
      await taskBox.put(id, updatedTask);
    }
  }
}