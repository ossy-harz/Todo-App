import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/task.dart';
import '../providers/tasks_provider.dart';

class TaskFilterChips extends ConsumerWidget {
  const TaskFilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFilter = ref.watch(taskFilterProvider);

    return Row(
      children: [
        FilterChip(
          label: const Text('All'),
          selected: currentFilter == TaskFilter.all,
          onSelected: (_) => ref.read(taskFilterProvider.notifier).state = TaskFilter.all,
        ),
        const SizedBox(width: 8),
        FilterChip(
          label: const Text('Active'),
          selected: currentFilter == TaskFilter.active,
          onSelected: (_) => ref.read(taskFilterProvider.notifier).state = TaskFilter.active,
        ),
        const SizedBox(width: 8),
        FilterChip(
          label: const Text('Completed'),
          selected: currentFilter == TaskFilter.completed,
          onSelected: (_) => ref.read(taskFilterProvider.notifier).state = TaskFilter.completed,
        ),
      ],
    );
  }
}
