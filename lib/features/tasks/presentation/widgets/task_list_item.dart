import 'package:flutter/material.dart';

import '../../domain/entities/task.dart';

class TaskListItem extends StatelessWidget {
  final Task task;
  final Function(Task) onToggle;
  final Function(Task) onDelete;
  final Function(Task)? onEdit;

  const TaskListItem({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final completionPercentage = task.completionPercentage;
    final category = TaskCategory.defaultCategories
        .where((c) => c.id == task.category)
        .firstOrNull;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          ListTile(
            leading: Checkbox(
              value: task.isCompleted,
              onChanged: (_) => onToggle(task),
            ),
            title: Text(
              task.title,
              style: TextStyle(
                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                color: task.isCompleted ? Colors.grey : null,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (task.description.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      task.description,
                      style: TextStyle(
                        color: task.isCompleted ? Colors.grey : null,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                const SizedBox(height: 8),
                
                // Progress bar for subtasks
                if (task.subtasks.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.checklist, size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              '${task.subtasks.where((s) => s.isCompleted).length}/${task.subtasks.length} subtasks',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: completionPercentage,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            completionPercentage == 1.0 ? Colors.green : Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                
                // Tags and metadata row
                Row(
                  children: [
                    // Priority chip
                    _PriorityChip(priority: task.priority),
                    
                    // Category chip
                    if (category != null) ...[
                      const SizedBox(width: 8),
                      Chip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(category.icon, style: const TextStyle(fontSize: 12)),
                            const SizedBox(width: 4),
                            Text(
                              category.name,
                              style: const TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                        backgroundColor: Color(int.parse(category.colorCode.substring(1), radix: 16) + 0xFF000000).withOpacity(0.1),
                        side: BorderSide(
                          color: Color(int.parse(category.colorCode.substring(1), radix: 16) + 0xFF000000).withOpacity(0.3),
                        ),
                      ),
                    ],
                    
                    // Due date chip
                    if (task.dueDate != null) ...[
                      const SizedBox(width: 8),
                      _DueDateChip(dueDate: task.dueDate!),
                    ],
                    
                    // Recurrence indicator
                    if (task.recurrenceType != null) ...[
                      const SizedBox(width: 8),
                      Icon(
                        Icons.repeat,
                        size: 16,
                        color: Colors.blue[600],
                      ),
                    ],
                    
                    // Reminder indicator
                    if (task.hasReminder) ...[
                      const SizedBox(width: 8),
                      Icon(
                        Icons.notifications_active,
                        size: 16,
                        color: Colors.orange[600],
                      ),
                    ],
                  ],
                ),
                
                // Tags
                if (task.tags.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: task.tags.take(3).map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue[200]!),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.blue[700],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                if (onEdit != null)
                  PopupMenuItem(
                    value: 'edit',
                    child: const Row(
                      children: [
                        Icon(Icons.edit, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                PopupMenuItem(
                  value: 'delete',
                  child: const Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete'),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'edit' && onEdit != null) {
                  onEdit!(task);
                } else if (value == 'delete') {
                  _showDeleteConfirmation(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDelete(task);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _PriorityChip extends StatelessWidget {
  final TaskPriority priority;

  const _PriorityChip({required this.priority});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;

    switch (priority) {
      case TaskPriority.low:
        color = Colors.green;
        icon = Icons.keyboard_arrow_down;
        break;
      case TaskPriority.medium:
        color = Colors.orange;
        icon = Icons.remove;
        break;
      case TaskPriority.high:
        color = Colors.red;
        icon = Icons.keyboard_arrow_up;
        break;
    }

    return Chip(
      label: Text(
        priority.name.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      avatar: Icon(icon, color: color, size: 16),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color.withOpacity(0.3)),
    );
  }
}

class _DueDateChip extends StatelessWidget {
  final DateTime dueDate;

  const _DueDateChip({required this.dueDate});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isOverdue = dueDate.isBefore(now);
    final isDueToday = dueDate.day == now.day &&
        dueDate.month == now.month &&
        dueDate.year == now.year;

    Color color = Colors.blue;
    if (isOverdue) {
      color = Colors.red;
    } else if (isDueToday) {
      color = Colors.orange;
    }

    return Chip(
      label: Text(
        '${dueDate.day}/${dueDate.month}',
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      avatar: Icon(Icons.calendar_today, color: color, size: 16),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color.withOpacity(0.3)),
    );
  }
}
