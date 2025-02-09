import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_management_app/models/task_model.dart';

import 'hive_service.dart';

class FirebaseService {
  final CollectionReference _tasksCollection =
      FirebaseFirestore.instance.collection('tasks');
 

  Future<void> addTaskToFirebase(Task task) async {
    await _tasksCollection.doc(task.id).set(task.toMap());
  }

  Future<void> updateTaskInFirebase(Task task) async {
    await _tasksCollection.doc(task.id).update(task.toMap());
  }


  Future<void> deleteTaskFromFirebase(String taskId) async {
    await _tasksCollection.doc(taskId).delete();
  }

   Future<void> syncTasksWithFirestore(List<Task> localTasks) async {
    for (final task in localTasks) {
      final taskExists = await _tasksCollection.doc(task.id).get().then((doc) => doc.exists);
      if (taskExists) {
        await updateTaskInFirebase(task);
      } else {
        await addTaskToFirebase(task);
      }
    }
  }


  Future<void> resolveTaskConflict(Task localTask, HiveService hiveService) async {
    final remoteSnapshot = await _tasksCollection.doc(localTask.id).get();
    if (remoteSnapshot.exists) {
      final remoteTask = Task.fromMap(remoteSnapshot.data() as Map<String, dynamic>);
      if (localTask.updatedAt.isAfter(remoteTask.updatedAt)) {
        await updateTaskInFirebase(localTask);
      } else {
        await hiveService.updateTask(remoteTask);
      }
    }
  }
}