import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/task.dart';

class SubtaskEditor extends StatefulWidget {
  final List<Subtask> subtasks;
  final Function(List<Subtask>) onSubtasksChanged;

  const SubtaskEditor({
    super.key,
    required this.subtasks,
    required this.onSubtasksChanged,
  });

  @override
  State<SubtaskEditor> createState() => _SubtaskEditorState();
}

class _SubtaskEditorState extends State<SubtaskEditor> {
  final _subtaskController = TextEditingController();

  @override
  void dispose() {
    _subtaskController.dispose();
    super.dispose();
  }

  void _addSubtask() {
    final title = _subtaskController.text.trim();
    if (title.isNotEmpty) {
      final subtask = Subtask(
        id: const Uuid().v4(),
        title: title,
        isCompleted: false,
        createdAt: DateTime.now(),
      );
      final updatedSubtasks = [...widget.subtasks, subtask];
      widget.onSubtasksChanged(updatedSubtasks);
      _subtaskController.clear();
    }
  }

  void _toggleSubtask(int index) {
    final updatedSubtasks = [...widget.subtasks];
    updatedSubtasks[index] = updatedSubtasks[index].copyWith(
      isCompleted: !updatedSubtasks[index].isCompleted,
    );
    widget.onSubtasksChanged(updatedSubtasks);
  }

  void _removeSubtask(int index) {
    final updatedSubtasks = [...widget.subtasks];
    updatedSubtasks.removeAt(index);
    widget.onSubtasksChanged(updatedSubtasks);
  }

  void _editSubtask(int index, String newTitle) {
    final updatedSubtasks = [...widget.subtasks];
    updatedSubtasks[index] = updatedSubtasks[index].copyWith(title: newTitle);
    widget.onSubtasksChanged(updatedSubtasks);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.checklist),
                const SizedBox(width: 8),
                Text(
                  'Subtasks',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                if (widget.subtasks.isNotEmpty)
                  Text(
                    '${widget.subtasks.where((s) => s.isCompleted).length}/${widget.subtasks.length}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _subtaskController,
                    decoration: const InputDecoration(
                      hintText: 'Add a subtask',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onSubmitted: (_) => _addSubtask(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addSubtask,
                  child: const Text('Add'),
                ),
              ],
            ),
            if (widget.subtasks.isNotEmpty) ...[
              const SizedBox(height: 12),
              ...widget.subtasks.asMap().entries.map((entry) {
                final index = entry.key;
                final subtask = entry.value;
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Checkbox(
                        value: subtask.isCompleted,
                        onChanged: (_) => _toggleSubtask(index),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _showEditDialog(index, subtask.title),
                          child: Text(
                            subtask.title,
                            style: TextStyle(
                              decoration: subtask.isCompleted 
                                  ? TextDecoration.lineThrough 
                                  : null,
                              color: subtask.isCompleted 
                                  ? Colors.grey 
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 20),
                        onPressed: () => _removeSubtask(index),
                        color: Colors.red,
                      ),
                    ],
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }

  void _showEditDialog(int index, String currentTitle) {
    final controller = TextEditingController(text: currentTitle);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Subtask'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Subtask title',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final newTitle = controller.text.trim();
              if (newTitle.isNotEmpty) {
                _editSubtask(index, newTitle);
              }
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
