import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/models/task_model.dart';
import '../services/firebase_service.dart';
import '../services/hive_service.dart';
import '../services/auth_service.dart';
import '../screens/add_task_screen.dart';
import '../screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Task> tasks;
  bool isOffline = false;
  bool isLoading = false;
   List<String> pendingDeletions = []; 

  @override
  void initState() {
    super.initState();
    tasks = [];
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() => isLoading = true);
    final hiveService = Provider.of<HiveService>(context, listen: false);
    tasks = hiveService.getAllTasks();
    setState(() => isLoading = false);
  }

  Future<void> _addTask(Task task) async {
    setState(() => isLoading = true);
    final hiveService = Provider.of<HiveService>(context, listen: false);
    final firebaseService =
        Provider.of<FirebaseService>(context, listen: false);

    await hiveService.saveTask(task);
    if (!isOffline) {
      await firebaseService.addTaskToFirebase(task);
    }
    await _loadTasks();
    setState(() => isLoading = false);
  }

  Future<void> _deleteTask(String taskId) async {
  setState(() => isLoading = true);
  final hiveService = Provider.of<HiveService>(context, listen: false);
  final firebaseService = Provider.of<FirebaseService>(context, listen: false);


  await hiveService.deleteTask(taskId);

  if (!isOffline) {
    await firebaseService.deleteTaskFromFirebase(taskId);
  } else {
    pendingDeletions.add(taskId);
  }

  await _loadTasks();
  setState(() => isLoading = false);
}

  Future<void> _syncTasks() async {
  setState(() => isLoading = true);
  final hiveService = Provider.of<HiveService>(context, listen: false);
  final firebaseService = Provider.of<FirebaseService>(context, listen: false);

  final localTasks = hiveService.getAllTasks();
  await firebaseService.syncTasksWithFirestore(localTasks);

  for (final taskId in pendingDeletions) {
    await firebaseService.deleteTaskFromFirebase(taskId);
  }
  pendingDeletions.clear();

  for (final task in localTasks) {
    await firebaseService.resolveTaskConflict(task, hiveService);
  }

  await _loadTasks();
  setState(() => isLoading = false);
}

  Future<void> _editTask(Task task) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskScreen(task: task),
      ),
    );

    if (result is Task) {
      setState(() => isLoading = true);
      final hiveService = Provider.of<HiveService>(context, listen: false);
      final firebaseService =
          Provider.of<FirebaseService>(context, listen: false);

      await hiveService.updateTask(result);
      if (!isOffline) {
        await firebaseService.updateTaskInFirebase(result);
      }
      await _loadTasks();
      setState(() => isLoading = false);
    }
  }

  Future<void> _logoutUser() async {
    setState(() => isLoading = true);
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.signOut();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        actions: [
          IconButton(
            icon: Icon(
              isOffline ? Icons.offline_bolt : Icons.wifi,
              color: isOffline
                  ? Colors.red
                  : Colors.green,
            ),
            onPressed: () {
              setState(() {
                isOffline = !isOffline;
              });
              if (!isOffline) {
                _syncTasks();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout,
                color: Colors.red),
            onPressed: _logoutUser,
            tooltip: 'Logout', 
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _editTask(task),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteTask(task.id),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
          if (result is Task) {
            _addTask(result);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
