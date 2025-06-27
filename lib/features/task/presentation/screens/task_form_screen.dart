import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/models/task_model.dart';
import '../providers/task_providers.dart';

class TaskFormScreen extends ConsumerStatefulWidget {
  final Task? task;

  const TaskFormScreen({super.key, this.task});

  @override
  ConsumerState<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends ConsumerState<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _noteController;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _noteController = TextEditingController(text: widget.task?.note ?? '');
    _selectedDate = widget.task?.dueDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Note',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'No due date selected'
                          : 'Due date: ${DateFormat('MMM d, yyyy').format(_selectedDate!)}',
                    ),
                  ),
                  TextButton(
                    onPressed: _pickDate,
                    child: Text(_selectedDate == null ? 'Select Date' : 'Change Date'),
                  ),
                  if (_selectedDate != null)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedDate = null;
                        });
                      },
                      child: const Text('Clear'),
                    ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveTask,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(isEditing ? 'Update Task' : 'Add Task'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text;
      final note = _noteController.text;

      if (widget.task == null) {
        // Create new task
        final newTask = Task(
          title: title,
          note: note,
          dueDate: _selectedDate,
        );
        ref.read(taskNotifierProvider.notifier).addTask(newTask);
      } else {
        // Update existing task
        final updatedTask = widget.task!.copyWith(
          title: title,
          note: note,
          dueDate: _selectedDate,
        );
        ref.read(taskNotifierProvider.notifier).updateTask(updatedTask);
      }

      Navigator.pop(context);
    }
  }
}