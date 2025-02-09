// File: tests/task_model_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:task_management_app/models/task_model.dart';


void main() {
  test('Task model serialization and deserialization', () {
    final task = Task(
      id: '1',
      title: 'Test Task',
      description: 'This is a test task',
      // isCompleted: false,
    );

    final map = task.toMap();
    final newTask = Task.fromMap(map);

    expect(newTask.id, task.id);
    expect(newTask.title, task.title);
    expect(newTask.description, task.description);
    // expect(newTask.isCompleted, task.isCompleted);
  });
}