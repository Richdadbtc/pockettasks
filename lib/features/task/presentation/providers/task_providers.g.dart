part of 'task_providers.dart';

String _$taskBoxHash() => r'c3c43b2b264fb42e817d851feea2fe300335240c';

@ProviderFor(taskBox)
final taskBoxProvider = AutoDisposeProvider<Box<Task>>.internal(
  taskBox,
  name: r'taskBoxProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$taskBoxHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
typedef TaskBoxRef = AutoDisposeProviderRef<Box<Task>>;
String _$filteredSortedTasksHash() =>
    r'77c7bc69902d63f3f3ea0afe7b8afac8a9d108d1';

@ProviderFor(filteredSortedTasks)
final filteredSortedTasksProvider =
    AutoDisposeFutureProvider<List<Task>>.internal(
  filteredSortedTasks,
  name: r'filteredSortedTasksProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredSortedTasksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
typedef FilteredSortedTasksRef = AutoDisposeFutureProviderRef<List<Task>>;
String _$taskNotifierHash() => r'f2a5ca5b19d576af815e6b7378af9cd8bf7a1957';

/// See also [TaskNotifier].
@ProviderFor(TaskNotifier)
final taskNotifierProvider =
    AutoDisposeAsyncNotifierProvider<TaskNotifier, List<Task>>.internal(
  TaskNotifier.new,
  name: r'taskNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$taskNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TaskNotifier = AutoDisposeAsyncNotifier<List<Task>>;
String _$taskFilterNotifierHash() =>
    r'7769beb4f9af3344c9b2df5e30448d8be0dbbedc';

/// See also [TaskFilterNotifier].
@ProviderFor(TaskFilterNotifier)
final taskFilterNotifierProvider =
    AutoDisposeNotifierProvider<TaskFilterNotifier, TaskFilter>.internal(
  TaskFilterNotifier.new,
  name: r'taskFilterNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$taskFilterNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TaskFilterNotifier = AutoDisposeNotifier<TaskFilter>;
String _$taskSortNotifierHash() => r'eef2fd135d41c18505e979179989714340b74578';

/// See also [TaskSortNotifier].
@ProviderFor(TaskSortNotifier)
final taskSortNotifierProvider =
    AutoDisposeNotifierProvider<TaskSortNotifier, TaskSort>.internal(
  TaskSortNotifier.new,
  name: r'taskSortNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$taskSortNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TaskSortNotifier = AutoDisposeNotifier<TaskSort>;
