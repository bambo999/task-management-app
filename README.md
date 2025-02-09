<<<<<<< HEAD
# task-management-app
=======
# task_management_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
>>>>>>> main



 Project Structure below:

lib/
├── main.dart
├── models/
│   └── task_model.dart
├── services/
│   ├── hive_service.dart
│   ├── firebase_service.dart
│   └── auth_service.dart
├── screens/
│   ├── home_screen.dart
│   ├── add_task_screen.dart
│   ├── login_screen.dart
│   └── register_screen.dart
├── widgets/
│   └── task_tile.dart
├── tests/
│   ├── task_model_test.dart
│   ├── hive_service_test.dart
│   └── home_screen_test.dart
├── pubspec.yaml
├── README.md

Login credentials:  Email: test@gmail.com  , password: 123456

To execute with your own firease instructions below: 

1. Create a firebase project and give your preferred name.
2. use the app Id while creating which is  com.example.task_management_app . once successful download google-services.json and replace the one in the project with yours
3. click on build on the left side then select firestore database then click on create to create yout task schema Id, title, description, createAt, updateAt
4. Launch the app and create account to login



   Data flow:
1. Adding a Task
- User add a task on the Add Task Screen (Using Float button)
- Task is saved to Hive(Local database)
- if online, task is also saved to firestore
- UI i Updates immediately

2. Editing a Task
- User Edit a task on the by clicking the edit icon
- Task is updated on hive
- if online, task is also updated in firestore
- Ui is updated immediately
3. Deleting a task
- Used delete a task from task list using delete icon
- Task is removed from hive
-  if offline, task ID is added to pending eletion list.
-if online, task is deleted from firestore.
-UI is updated immediately
4. Synchronization 
- when app is offling, the _syncTasks method is called
-Local tasks are synced with firestore
-Pending deletion are proessed and synced with firestore
-conflict are resolved by comparing updateAt Timesamps.

5. Comflict Resolution
Conflicts are resolved automatically by prioritizing the most recent update

6. Real Time Sync
-Tasks are synchronized in real-time across all devices using firebase firestore
