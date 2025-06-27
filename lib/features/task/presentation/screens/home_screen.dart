import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../providers/task_providers.dart';
import '../widgets/task_list.dart';
import 'task_form_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFilter = ref.watch(taskFilterNotifierProvider);
    final currentSort = ref.watch(taskSortNotifierProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pocket Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => _toggleTheme(ref),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterTabs(context, ref, currentFilter),
          _buildSortDropdown(context, ref, currentSort),
          const Expanded(child: TaskList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddTask(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterTabs(BuildContext context, WidgetRef ref, TaskFilter currentFilter) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildFilterTab(context, ref, TaskFilter.all, currentFilter),
          const SizedBox(width: 8),
          _buildFilterTab(context, ref, TaskFilter.active, currentFilter),
          const SizedBox(width: 8),
          _buildFilterTab(context, ref, TaskFilter.completed, currentFilter),
        ],
      ),
    );
  }

  Widget _buildFilterTab(BuildContext context, WidgetRef ref, TaskFilter filter, TaskFilter currentFilter) {
    final isSelected = filter == currentFilter;
    final theme = Theme.of(context);
    
    return Expanded(
      child: InkWell(
        onTap: () => _setFilter(ref, filter),
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.primary.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isSelected ? theme.colorScheme.primary : Colors.transparent,
              width: 1,
            ),
          ),
          child: Text(
            _getFilterName(filter),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? theme.colorScheme.primary : null,
              fontWeight: isSelected ? FontWeight.bold : null,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSortDropdown(BuildContext context, WidgetRef ref, TaskSort currentSort) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text('Sort by:'),
          const SizedBox(width: 8),
          DropdownButton<TaskSort>(
            value: currentSort,
            onChanged: (value) {
              if (value != null) {
                _setSort(ref, value);
              }
            },
            items: const [
              DropdownMenuItem(
                value: TaskSort.dueDate,
                child: Text('Due Date'),
              ),
              DropdownMenuItem(
                value: TaskSort.createdAt,
                child: Text('Created Date'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getFilterName(TaskFilter filter) {
    switch (filter) {
      case TaskFilter.all:
        return 'All';
      case TaskFilter.active:
        return 'Active';
      case TaskFilter.completed:
        return 'Completed';
    }
  }

  void _setFilter(WidgetRef ref, TaskFilter filter) {
    ref.read(taskFilterNotifierProvider.notifier).setFilter(filter);
  }

  void _setSort(WidgetRef ref, TaskSort sort) {
    ref.read(taskSortNotifierProvider.notifier).setSort(sort);
  }

  void _toggleTheme(WidgetRef ref) {
    ref.read(themeProvider.notifier).toggleTheme();
  }

  void _navigateToAddTask(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TaskFormScreen(),
      ),
    );
  }
}