import '../entities/task.dart';

abstract class TaskRepository {
  Stream<List<Task>> getTasks();
  Future<void> addTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String taskId);
  Future<Task?> getTask(String taskId);
}
