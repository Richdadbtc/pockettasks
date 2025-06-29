import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import '../../domain/models/task_model.dart';
import '../providers/task_providers.dart';
import '../screens/task_form_screen.dart';

class TaskList extends ConsumerWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(filteredSortedTasksProvider);

    return tasksAsync.when(
      data: (tasks) {
        if (tasks.isEmpty) {
          return const Center(
            child: Text('No tasks found'),
          );
        }

        return AnimatedList(
          initialItemCount: tasks.length,
          itemBuilder: (context, index, animation) {
            final task = tasks[index];
            return _buildTaskItem(context, ref, task, animation);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Text('Error: $error'),
      ),
    );
  }

  Widget _buildTaskItem(BuildContext context, WidgetRef ref, Task task, Animation<double> animation) {
    final theme = Theme.of(context);
    
    return SizeTransition(
      sizeFactor: animation,
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _deleteTask(ref, task.id),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: const BorderRadius.horizontal(right: Radius.circular(16)),
            ),
          ],
        ),
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              ListTile(
                leading: Checkbox(
                  value: task.isCompleted,
                  onChanged: (_) => _toggleTaskCompletion(ref, task.id),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                title: Text(
                  task.title,
                  style: TextStyle(
                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(task.note),
                trailing: task.dueDate != null
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: _isOverdue(task) 
                              ? Colors.red.withOpacity(0.1) 
                              : theme.colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          DateFormat('MMM d').format(task.dueDate!),
                          style: TextStyle(
                            color: _isOverdue(task) ? Colors.red : theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      )
                    : null,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0, bottom: 8.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () => _navigateToEditTask(context, task),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Edit Task'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isOverdue(Task task) {
    if (task.dueDate == null || task.isCompleted) return false;
    final now = DateTime.now();
    return task.dueDate!.isBefore(DateTime(now.year, now.month, now.day));
  }

  void _toggleTaskCompletion(WidgetRef ref, String taskId) {
    ref.read(taskNotifierProvider.notifier).toggleTaskCompletion(taskId);
  }

  void _deleteTask(WidgetRef ref, String taskId) {
    ref.read(taskNotifierProvider.notifier).deleteTask(taskId);
  }

  void _navigateToEditTask(BuildContext context, Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(task: task),
      ),
    );
  }
}