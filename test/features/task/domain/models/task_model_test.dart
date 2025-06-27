import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_tasks/features/task/domain/models/task_model.dart';

void main() {
  group('Task Model', () {
    test('should create a Task with default values', () {
      final task = Task(title: 'Test Task');
      
      expect(task.title, 'Test Task');
      expect(task.note, '');
      expect(task.isCompleted, false);
      expect(task.id, isNotNull);
      expect(task.createdAt, isNotNull);
      expect(task.dueDate, isNull);
    });
    
    test('should create a Task with provided values', () {
      final now = DateTime.now();
      final dueDate = now.add(const Duration(days: 1));
      final task = Task(
        id: '123',
        title: 'Test Task',
        note: 'Test Note',
        dueDate: dueDate,
        isCompleted: true,
        createdAt: now,
      );
      
      expect(task.id, '123');
      expect(task.title, 'Test Task');
      expect(task.note, 'Test Note');
      expect(task.dueDate, dueDate);
      expect(task.isCompleted, true);
      expect(task.createdAt, now);
    });
    
    test('should correctly copy with new values', () {
      final task = Task(title: 'Original Title', note: 'Original Note');
      final copiedTask = task.copyWith(
        title: 'New Title',
        isCompleted: true,
      );
      
      expect(copiedTask.id, task.id); // ID should remain the same
      expect(copiedTask.title, 'New Title');
      expect(copiedTask.note, 'Original Note'); // Unchanged
      expect(copiedTask.isCompleted, true);
      expect(copiedTask.createdAt, task.createdAt); // Should remain the same
    });
  });
}