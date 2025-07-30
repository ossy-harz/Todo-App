import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';

import 'package:todo_app/features/tasks/domain/entities/task.dart';
import 'package:todo_app/features/tasks/presentation/widgets/task_list_item.dart';

class MockTask extends Mock implements Task {}

void main() {
  group('TaskListItem Widget Tests', () {
    late Task mockTask;

    setUp(() {
      mockTask = Task(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        isCompleted: false,
        createdAt: DateTime.now(),
        userId: 'user1',
        priority: TaskPriority.medium,
      );
    });

    testWidgets('displays task title and description', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: TaskListItem(
                task: mockTask,
                onToggle: (_) {},
                onDelete: (_) {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Test Task'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
    });

    testWidgets('shows completed state correctly', (tester) async {
      final completedTask = mockTask.copyWith(isCompleted: true);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: TaskListItem(
                task: completedTask,
                onToggle: (_) {},
                onDelete: (_) {},
              ),
            ),
          ),
        ),
      );

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, isTrue);
    });

    testWidgets('calls onToggle when checkbox is tapped', (tester) async {
      bool toggleCalled = false;
      Task? toggledTask;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: TaskListItem(
                task: mockTask,
                onToggle: (task) {
                  toggleCalled = true;
                  toggledTask = task;
                },
                onDelete: (_) {},
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      expect(toggleCalled, isTrue);
      expect(toggledTask, equals(mockTask));
    });
  });

  group('Task Entity Tests', () {
    test('creates task with required fields', () {
      final task = Task(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        isCompleted: false,
        createdAt: DateTime.now(),
        userId: 'user1',
      );

      expect(task.id, equals('1'));
      expect(task.title, equals('Test Task'));
      expect(task.isCompleted, isFalse);
      expect(task.priority, equals(TaskPriority.medium));
    });

    test('copyWith creates new instance with updated fields', () {
      final originalTask = Task(
        id: '1',
        title: 'Original Title',
        description: 'Original Description',
        isCompleted: false,
        createdAt: DateTime.now(),
        userId: 'user1',
      );

      final updatedTask = originalTask.copyWith(
        title: 'Updated Title',
        isCompleted: true,
      );

      expect(updatedTask.title, equals('Updated Title'));
      expect(updatedTask.isCompleted, isTrue);
      expect(updatedTask.description, equals('Original Description'));
      expect(updatedTask.id, equals(originalTask.id));
    });

    test('equality works correctly', () {
      final task1 = Task(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        isCompleted: false,
        createdAt: DateTime(2024, 1, 1),
        userId: 'user1',
      );

      final task2 = Task(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        isCompleted: false,
        createdAt: DateTime(2024, 1, 1),
        userId: 'user1',
      );

      expect(task1, equals(task2));
    });
  });
}
