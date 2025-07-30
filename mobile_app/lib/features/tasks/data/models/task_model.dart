import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/task.dart';

class TaskModel {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? dueDate;
  final DateTime? completedAt;
  final String userId;
  final String priority;
  final List<String> tags;
  final String? category;
  final List<SubtaskModel> subtasks;
  final String? recurrenceType;
  final int? recurrenceInterval;
  final DateTime? nextRecurrence;
  final double progress;
  final String? colorCode;
  final bool hasReminder;
  final DateTime? reminderTime;
  final int sortOrder;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.createdAt,
    this.dueDate,
    this.completedAt,
    required this.userId,
    required this.priority,
    required this.tags,
    this.category,
    required this.subtasks,
    this.recurrenceType,
    this.recurrenceInterval,
    this.nextRecurrence,
    required this.progress,
    this.colorCode,
    required this.hasReminder,
    this.reminderTime,
    required this.sortOrder,
  });

  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      isCompleted: data['isCompleted'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      dueDate: data['dueDate'] != null ? (data['dueDate'] as Timestamp).toDate() : null,
      completedAt: data['completedAt'] != null ? (data['completedAt'] as Timestamp).toDate() : null,
      userId: data['userId'] ?? '',
      priority: data['priority'] ?? 'medium',
      tags: List<String>.from(data['tags'] ?? []),
      category: data['category'],
      subtasks: (data['subtasks'] as List<dynamic>? ?? [])
          .map((s) => SubtaskModel.fromMap(s as Map<String, dynamic>))
          .toList(),
      recurrenceType: data['recurrenceType'],
      recurrenceInterval: data['recurrenceInterval'],
      nextRecurrence: data['nextRecurrence'] != null 
          ? (data['nextRecurrence'] as Timestamp).toDate() 
          : null,
      progress: (data['progress'] ?? 0.0).toDouble(),
      colorCode: data['colorCode'],
      hasReminder: data['hasReminder'] ?? false,
      reminderTime: data['reminderTime'] != null 
          ? (data['reminderTime'] as Timestamp).toDate() 
          : null,
      sortOrder: data['sortOrder'] ?? 0,
    );
  }

  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      isCompleted: task.isCompleted,
      createdAt: task.createdAt,
      dueDate: task.dueDate,
      completedAt: task.completedAt,
      userId: task.userId,
      priority: task.priority.name,
      tags: task.tags,
      category: task.category,
      subtasks: task.subtasks.map((s) => SubtaskModel.fromEntity(s)).toList(),
      recurrenceType: task.recurrenceType?.name,
      recurrenceInterval: task.recurrenceInterval,
      nextRecurrence: task.nextRecurrence,
      progress: task.progress,
      colorCode: task.colorCode,
      hasReminder: task.hasReminder,
      reminderTime: task.reminderTime,
      sortOrder: task.sortOrder,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': Timestamp.fromDate(createdAt),
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'userId': userId,
      'priority': priority,
      'tags': tags,
      'category': category,
      'subtasks': subtasks.map((s) => s.toMap()).toList(),
      'recurrenceType': recurrenceType,
      'recurrenceInterval': recurrenceInterval,
      'nextRecurrence': nextRecurrence != null ? Timestamp.fromDate(nextRecurrence!) : null,
      'progress': progress,
      'colorCode': colorCode,
      'hasReminder': hasReminder,
      'reminderTime': reminderTime != null ? Timestamp.fromDate(reminderTime!) : null,
      'sortOrder': sortOrder,
    };
  }

  Task toEntity() {
    return Task(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted,
      createdAt: createdAt,
      dueDate: dueDate,
      completedAt: completedAt,
      userId: userId,
      priority: TaskPriority.values.firstWhere(
        (p) => p.name == priority,
        orElse: () => TaskPriority.medium,
      ),
      tags: tags,
      category: category,
      subtasks: subtasks.map((s) => s.toEntity()).toList(),
      recurrenceType: recurrenceType != null 
          ? RecurrenceType.values.firstWhere((r) => r.name == recurrenceType)
          : null,
      recurrenceInterval: recurrenceInterval,
      nextRecurrence: nextRecurrence,
      progress: progress,
      colorCode: colorCode,
      hasReminder: hasReminder,
      reminderTime: reminderTime,
      sortOrder: sortOrder,
    );
  }
}

class SubtaskModel {
  final String id;
  final String title;
  final bool isCompleted;
  final DateTime createdAt;

  SubtaskModel({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.createdAt,
  });

  factory SubtaskModel.fromMap(Map<String, dynamic> map) {
    return SubtaskModel(
      id: map['id'] ?? const Uuid().v4(),
      title: map['title'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  factory SubtaskModel.fromEntity(Subtask subtask) {
    return SubtaskModel(
      id: subtask.id,
      title: subtask.title,
      isCompleted: subtask.isCompleted,
      createdAt: subtask.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  Subtask toEntity() {
    return Subtask(
      id: id,
      title: title,
      isCompleted: isCompleted,
      createdAt: createdAt,
    );
  }
}
