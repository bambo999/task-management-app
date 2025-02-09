import 'package:hive_flutter/hive_flutter.dart';
import '../models/task_model.dart';

class HiveService {
  static const String boxName = 'tasks_box';

  Future<void> initializeHive() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TaskAdapter());
    }
    await Hive.openBox<Task>(boxName);
  }

  Box<Task> getTasksBox() => Hive.box<Task>(boxName);

  Future<void> saveTask(Task task) async {
    final box = getTasksBox();
    await box.put(task.id, task);
  }

  List<Task> getAllTasks() {
    final box = getTasksBox();
    return box.values.toList();
  }

  Future<void> deleteTask(String taskId) async {
    final box = getTasksBox();
    await box.delete(taskId);
  }

  Future<void> updateTask(Task updatedTask) async {
    final box = getTasksBox();
    await box.put(updatedTask.id, updatedTask);
  }
}