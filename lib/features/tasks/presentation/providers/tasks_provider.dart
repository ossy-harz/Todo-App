import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../../data/repositories/task_repository_impl.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepositoryImpl();
});

final tasksProvider = StreamProvider<List<Task>>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return repository.getTasks();
});

final taskFilterProvider = StateProvider<TaskFilter>((ref) => TaskFilter.all);

final filteredTasksProvider = Provider<AsyncValue<List<Task>>>((ref) {
  final tasksAsync = ref.watch(tasksProvider);
  final filter = ref.watch(taskFilterProvider);

  return tasksAsync.when(
    data: (tasks) {
      List<Task> filteredTasks;
      switch (filter) {
        case TaskFilter.active:
          filteredTasks = tasks.where((task) => !task.isCompleted).toList();
          break;
        case TaskFilter.completed:
          filteredTasks = tasks.where((task) => task.isCompleted).toList();
          break;
        case TaskFilter.all:
        default:
          filteredTasks = tasks;
      }
      return AsyncValue.data(filteredTasks);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

final taskStatsProvider = Provider<Map<String, int>>((ref) {
  final tasksAsync = ref.watch(tasksProvider);
  
  return tasksAsync.when(
    data: (tasks) {
      final total = tasks.length;
      final completed = tasks.where((task) => task.isCompleted).length;
      final active = total - completed;
      
      return {
        'total': total,
        'completed': completed,
        'active': active,
      };
    },
    loading: () => {'total': 0, 'completed': 0, 'active': 0},
    error: (_, __) => {'total': 0, 'completed': 0, 'active': 0},
  );
});
