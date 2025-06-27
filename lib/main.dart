import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pocket_tasks/features/task/presentation/providers/task_providers.dart';
import 'core/theme/app_theme.dart';
import 'features/task/domain/models/task_adapter.dart' as adapter;
import 'features/task/domain/models/task_model.dart';
import 'features/task/presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);
  
  // Register Hive adapters
  Hive.registerAdapter(adapter.TaskAdapter());


  // Open Hive box
  final taskBox = await Hive.openBox<Task>('tasks');
  
  // Add some sample tasks if the box is empty
  if (taskBox.isEmpty) {
    final now = DateTime.now();
    await taskBox.put('1', Task(
      id: '1',
      title: 'Buy groceries',
      note: 'Get fruits, vegetables, and milk',
      dueDate: now,
      createdAt: now.subtract(const Duration(days: 1)),
    ));
    
    await taskBox.put('2', Task(
      id: '2',
      title: 'Finish the report',
      note: 'Complete the financial report',
      dueDate: now.add(const Duration(days: 2)),
      createdAt: now.subtract(const Duration(days: 2)),
    ));
    
    await taskBox.put('3', Task(
      id: '3',
      title: 'Call plumber',
      note: 'Fix the kitchen sink leak',
      dueDate: now.add(const Duration(days: 1)),
      createdAt: now.subtract(const Duration(hours: 12)),
    ));
    
    await taskBox.put('4', Task(
      id: '4',
      title: 'Read a book',
      note: 'Start reading "The Great Gatsby"',
      isCompleted: true,
      createdAt: now.subtract(const Duration(days: 5)),
    ));
  }
  
  // Run the app with ProviderScope
  runApp(
    ProviderScope(
      overrides: [
        taskBoxProvider.overrideWithValue(taskBox),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    
    return MaterialApp(
      title: 'Pocket Tasks',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
