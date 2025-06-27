import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_tasks/features/task/domain/models/task_model.dart';
import 'package:pocket_tasks/features/task/presentation/providers/task_providers.dart';
import 'package:pocket_tasks/features/task/presentation/widgets/task_list.dart';


class MockTaskNotifier extends TaskNotifier {
  @override
  Future<List<Task>> build() async {
    return [
      Task(
        id: '1',
        title: 'Mock Task 1',
        note: 'Mock Note 1',
        createdAt: DateTime.now(),
      ),
      Task(
        id: '2',
        title: 'Mock Task 2',
        note: 'Mock Note 2',
        isCompleted: true,
        createdAt: DateTime.now(),
      ),
    ];
  }

  @override
  Future<void> addTask(Task task) async {}

  @override
  Future<void> deleteTask(String id) async {}

  @override
  Future<void> toggleTaskCompletion(String id) async {}

  @override
  Future<void> updateTask(Task task) async {}
}



void main() {
  testWidgets('TaskList should display tasks', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          taskNotifierProvider.overrideWith(() => MockTaskNotifier()),
          filteredSortedTasksProvider.overrideWith((ref) async {
            return [
              Task(
                id: '1',
                title: 'Test Task 1',
                note: 'Test Note 1',
                createdAt: DateTime.now(),
              ),
              Task(
                id: '2',
                title: 'Test Task 2',
                note: 'Test Note 2',
                isCompleted: true,
                createdAt: DateTime.now(),
              ),
            ];
          }),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: TaskList(),
          ),
        ),
      ),
    );
    
    await tester.pumpAndSettle();
    
    expect(find.text('Test Task 1'), findsOneWidget);
    expect(find.text('Test Note 1'), findsOneWidget);
    expect(find.text('Test Task 2'), findsOneWidget);
    expect(find.text('Test Note 2'), findsOneWidget);
    
    // Check if the second task is marked as completed
    final secondTaskTitle = tester.widget<Text>(
      find.text('Test Task 2'),
    );
    expect(secondTaskTitle.style?.decoration, equals(TextDecoration.lineThrough));
  });
}