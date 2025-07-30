import 'package:flutter/material.dart';

import '../../domain/entities/task.dart';

class RecurrenceSelector extends StatelessWidget {
  final RecurrenceType? recurrenceType;
  final int recurrenceInterval;
  final Function(RecurrenceType?, int) onRecurrenceChanged;

  const RecurrenceSelector({
    super.key,
    required this.recurrenceType,
    required this.recurrenceInterval,
    required this.onRecurrenceChanged,
  });

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
                const Icon(Icons.repeat),
                const SizedBox(width: 8),
                Text(
                  'Recurrence',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<RecurrenceType?>(
              value: recurrenceType,
              decoration: const InputDecoration(
                labelText: 'Repeat',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<RecurrenceType?>(
                  value: null,
                  child: Text('Never'),
                ),
                ...RecurrenceType.values.map((type) {
                  return DropdownMenuItem<RecurrenceType?>(
                    value: type,
                    child: Text(_getRecurrenceLabel(type)),
                  );
                }),
              ],
              onChanged: (value) {
                onRecurrenceChanged(value, recurrenceInterval);
              },
            ),
            if (recurrenceType != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Every'),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 80,
                    child: TextFormField(
                      initialValue: recurrenceInterval.toString(),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      onChanged: (value) {
                        final interval = int.tryParse(value) ?? 1;
                        onRecurrenceChanged(recurrenceType, interval);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(_getIntervalLabel(recurrenceType!, recurrenceInterval)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getRecurrenceLabel(RecurrenceType type) {
    switch (type) {
      case RecurrenceType.daily:
        return 'Daily';
      case RecurrenceType.weekly:
        return 'Weekly';
      case RecurrenceType.monthly:
        return 'Monthly';
      case RecurrenceType.yearly:
        return 'Yearly';
    }
  }

  String _getIntervalLabel(RecurrenceType type, int interval) {
    switch (type) {
      case RecurrenceType.daily:
        return interval == 1 ? 'day' : 'days';
      case RecurrenceType.weekly:
        return interval == 1 ? 'week' : 'weeks';
      case RecurrenceType.monthly:
        return interval == 1 ? 'month' : 'months';
      case RecurrenceType.yearly:
        return interval == 1 ? 'year' : 'years';
    }
  }
}
