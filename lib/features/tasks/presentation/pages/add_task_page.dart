import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/task.dart';
import '../providers/tasks_provider.dart';
import '../widgets/subtask_editor.dart';
import '../widgets/category_selector.dart';
import '../widgets/tag_editor.dart';
import '../widgets/recurrence_selector.dart';
import '../../../../core/services/notification_service.dart';

class AddTaskPage extends ConsumerStatefulWidget {
  final Task? task; // For editing existing tasks

  const AddTaskPage({super.key, this.task});

  @override
  ConsumerState<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends ConsumerState<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  DateTime? _dueDate;
  DateTime? _reminderTime;
  TaskPriority _priority = TaskPriority.medium;
  String? _selectedCategory;
  List<String> _tags = [];
  List<Subtask> _subtasks = [];
  RecurrenceType? _recurrenceType;
  int _recurrenceInterval = 1;
  bool _hasReminder = false;
  String? _colorCode;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _initializeFromTask(widget.task!);
    }
  }

  void _initializeFromTask(Task task) {
    _titleController.text = task.title;
    _descriptionController.text = task.description;
    _dueDate = task.dueDate;
    _reminderTime = task.reminderTime;
    _priority = task.priority;
    _selectedCategory = task.category;
    _tags = List.from(task.tags);
    _subtasks = List.from(task.subtasks);
    _recurrenceType = task.recurrenceType;
    _recurrenceInterval = task.recurrenceInterval ?? 1;
    _hasReminder = task.hasReminder;
    _colorCode = task.colorCode;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: _dueDate != null 
            ? TimeOfDay.fromDateTime(_dueDate!) 
            : TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          _dueDate = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _selectReminderTime() async {
    if (_dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please set a due date first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final time = await showTimePicker(
      context: context,
      initialTime: _reminderTime != null 
          ? TimeOfDay.fromDateTime(_reminderTime!) 
          : TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        _reminderTime = DateTime(
          _dueDate!.year,
          _dueDate!.month,
          _dueDate!.day,
          time.hour,
          time.minute,
        );
        _hasReminder = true;
      });
    }
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser!;
      final taskId = widget.task?.id ?? const Uuid().v4();
      
      final task = Task(
        id: taskId,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        isCompleted: widget.task?.isCompleted ?? false,
        createdAt: widget.task?.createdAt ?? DateTime.now(),
        dueDate: _dueDate,
        userId: user.uid,
        priority: _priority,
        tags: _tags,
        category: _selectedCategory,
        subtasks: _subtasks,
        recurrenceType: _recurrenceType,
        recurrenceInterval: _recurrenceInterval,
        hasReminder: _hasReminder,
        reminderTime: _reminderTime,
        colorCode: _colorCode,
        sortOrder: widget.task?.sortOrder ?? 0,
      );

      final repository = ref.read(taskRepositoryProvider);
      
      if (widget.task != null) {
        await repository.updateTask(task);
      } else {
        await repository.addTask(task);
      }

      // Schedule notifications
      if (_hasReminder && _reminderTime != null) {
        await NotificationService.scheduleTaskReminder(
          id: task.id.hashCode,
          title: 'Task Reminder',
          body: task.title,
          scheduledDate: _reminderTime!,
          payload: task.id,
        );
      }

      // Schedule recurring notifications
      if (_recurrenceType != null && _dueDate != null) {
        RepeatInterval interval;
        switch (_recurrenceType!) {
          case RecurrenceType.daily:
            interval = RepeatInterval.daily;
            break;
          case RecurrenceType.weekly:
            interval = RepeatInterval.weekly;
            break;
          case RecurrenceType.monthly:
            interval = RepeatInterval.everyMinute; // Placeholder - needs custom implementation
            break;
          case RecurrenceType.yearly:
            interval = RepeatInterval.everyMinute; // Placeholder - needs custom implementation
            break;
        }

        if (_recurrenceType == RecurrenceType.daily || _recurrenceType == RecurrenceType.weekly) {
          await NotificationService.scheduleRecurringReminder(
            id: task.id.hashCode + 1000,
            title: 'Recurring Task',
            body: task.title,
            scheduledDate: _dueDate!,
            repeatInterval: interval,
            payload: task.id,
          );
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.task != null 
                ? 'Task updated successfully!' 
                : 'Task created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/tasks');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save task: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task != null ? 'Edit Task' : 'Add Task'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveTask,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                hintText: 'Enter task title',
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a task title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter task description (optional)',
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            // Priority
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.priority_high),
                        const SizedBox(width: 8),
                        Text(
                          'Priority',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SegmentedButton<TaskPriority>(
                      segments: const [
                        ButtonSegment(
                          value: TaskPriority.low,
                          label: Text('Low'),
                          icon: Icon(Icons.keyboard_arrow_down, color: Colors.green),
                        ),
                        ButtonSegment(
                          value: TaskPriority.medium,
                          label: Text('Medium'),
                          icon: Icon(Icons.remove, color: Colors.orange),
                        ),
                        ButtonSegment(
                          value: TaskPriority.high,
                          label: Text('High'),
                          icon: Icon(Icons.keyboard_arrow_up, color: Colors.red),
                        ),
                      ],
                      selected: {_priority},
                      onSelectionChanged: (Set<TaskPriority> selection) {
                        setState(() {
                          _priority = selection.first;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Category
            CategorySelector(
              selectedCategory: _selectedCategory,
              onCategorySelected: (category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),
            const SizedBox(height: 16),

            // Tags
            TagEditor(
              tags: _tags,
              onTagsChanged: (tags) {
                setState(() {
                  _tags = tags;
                });
              },
            ),
            const SizedBox(height: 16),

            // Due Date
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Due Date'),
                subtitle: _dueDate != null
                    ? Text(
                        '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year} at ${_dueDate!.hour.toString().padLeft(2, '0')}:${_dueDate!.minute.toString().padLeft(2, '0')}',
                      )
                    : const Text('No due date set'),
                trailing: _dueDate != null
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() {
                          _dueDate = null;
                          _reminderTime = null;
                          _hasReminder = false;
                        }),
                      )
                    : null,
                onTap: _selectDueDate,
              ),
            ),
            const SizedBox(height: 16),

            // Reminder
            if (_dueDate != null)
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      secondary: const Icon(Icons.notifications),
                      title: const Text('Set Reminder'),
                      subtitle: _hasReminder && _reminderTime != null
                          ? Text(
                              'Remind at ${_reminderTime!.hour.toString().padLeft(2, '0')}:${_reminderTime!.minute.toString().padLeft(2, '0')}',
                            )
                          : const Text('No reminder set'),
                      value: _hasReminder,
                      onChanged: (value) {
                        setState(() {
                          _hasReminder = value;
                          if (value && _reminderTime == null) {
                            _selectReminderTime();
                          }
                        });
                      },
                    ),
                    if (_hasReminder)
                      ListTile(
                        leading: const SizedBox(width: 24),
                        title: const Text('Reminder Time'),
                        subtitle: _reminderTime != null
                            ? Text(
                                '${_reminderTime!.hour.toString().padLeft(2, '0')}:${_reminderTime!.minute.toString().padLeft(2, '0')}',
                              )
                            : const Text('Tap to set time'),
                        onTap: _selectReminderTime,
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 16),

            // Recurrence
            RecurrenceSelector(
              recurrenceType: _recurrenceType,
              recurrenceInterval: _recurrenceInterval,
              onRecurrenceChanged: (type, interval) {
                setState(() {
                  _recurrenceType = type;
                  _recurrenceInterval = interval;
                });
              },
            ),
            const SizedBox(height: 16),

            // Subtasks
            SubtaskEditor(
              subtasks: _subtasks,
              onSubtasksChanged: (subtasks) {
                setState(() {
                  _subtasks = subtasks;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
