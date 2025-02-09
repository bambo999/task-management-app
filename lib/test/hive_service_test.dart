import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:task_management_app/models/task_model.dart';
import 'package:task_management_app/services/hive_service.dart';


void main() {
  late HiveService hiveService;

  setUpAll(() async {
    hiveService = HiveService();
    await hiveService.initializeHive();
  });

  tearDownAll(() async {
    await Hive.close();
  });

  test('Save and retrieve tasks', () async {
    final task = Task(
      id: '1',
      title: 'Test Task',
      description: 'This is a test task',
    );

    await hiveService.saveTask(task);
    final tasks = hiveService.getAllTasks();

    expect(tasks.length, 1);
    expect(tasks.first.title, 'Test Task');
  });
}


