import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? dueDate;
  final DateTime? completedAt;
  final String userId;
  final TaskPriority priority;
  final List<String> tags;
  final String? category;
  final List<Subtask> subtasks;
  final RecurrenceType? recurrenceType;
  final int? recurrenceInterval;
  final DateTime? nextRecurrence;
  final double progress;
  final String? colorCode;
  final bool hasReminder;
  final DateTime? reminderTime;
  final int sortOrder;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.createdAt,
    this.dueDate,
    this.completedAt,
    required this.userId,
    this.priority = TaskPriority.medium,
    this.tags = const [],
    this.category,
    this.subtasks = const [],
    this.recurrenceType,
    this.recurrenceInterval,
    this.nextRecurrence,
    this.progress = 0.0,
    this.colorCode,
    this.hasReminder = false,
    this.reminderTime,
    this.sortOrder = 0,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? dueDate,
    DateTime? completedAt,
    String? userId,
    TaskPriority? priority,
    List<String>? tags,
    String? category,
    List<Subtask>? subtasks,
    RecurrenceType? recurrenceType,
    int? recurrenceInterval,
    DateTime? nextRecurrence,
    double? progress,
    String? colorCode,
    bool? hasReminder,
    DateTime? reminderTime,
    int? sortOrder,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
      userId: userId ?? this.userId,
      priority: priority ?? this.priority,
      tags: tags ?? this.tags,
      category: category ?? this.category,
      subtasks: subtasks ?? this.subtasks,
      recurrenceType: recurrenceType ?? this.recurrenceType,
      recurrenceInterval: recurrenceInterval ?? this.recurrenceInterval,
      nextRecurrence: nextRecurrence ?? this.nextRecurrence,
      progress: progress ?? this.progress,
      colorCode: colorCode ?? this.colorCode,
      hasReminder: hasReminder ?? this.hasReminder,
      reminderTime: reminderTime ?? this.reminderTime,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  double get completionPercentage {
    if (subtasks.isEmpty) {
      return isCompleted ? 1.0 : progress;
    }
    final completedSubtasks = subtasks.where((s) => s.isCompleted).length;
    return completedSubtasks / subtasks.length;
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        isCompleted,
        createdAt,
        dueDate,
        completedAt,
        userId,
        priority,
        tags,
        category,
        subtasks,
        recurrenceType,
        recurrenceInterval,
        nextRecurrence,
        progress,
        colorCode,
        hasReminder,
        reminderTime,
        sortOrder,
      ];
}

class Subtask extends Equatable {
  final String id;
  final String title;
  final bool isCompleted;
  final DateTime createdAt;

  const Subtask({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.createdAt,
  });

  Subtask copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return Subtask(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, title, isCompleted, createdAt];
}

enum TaskPriority { low, medium, high }

enum TaskFilter { all, active, completed, overdue, today, thisWeek }

enum RecurrenceType { daily, weekly, monthly, yearly }

class TaskCategory {
  final String id;
  final String name;
  final String colorCode;
  final String icon;

  const TaskCategory({
    required this.id,
    required this.name,
    required this.colorCode,
    required this.icon,
  });

  static const List<TaskCategory> defaultCategories = [
    TaskCategory(id: 'work', name: 'Work', colorCode: '#2563EB', icon: '💼'),
    TaskCategory(id: 'personal', name: 'Personal', colorCode: '#10B981', icon: '🏠'),
    TaskCategory(id: 'errands', name: 'Errands', colorCode: '#F59E0B', icon: '🛒'),
    TaskCategory(id: 'health', name: 'Health', colorCode: '#EF4444', icon: '🏥'),
    TaskCategory(id: 'learning', name: 'Learning', colorCode: '#8B5CF6', icon: '📚'),
    TaskCategory(id: 'social', name: 'Social', colorCode: '#EC4899', icon: '👥'),
  ];
}
