import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/screens/login_screen.dart';
import 'package:task_management_app/services/hive_service.dart';
import 'package:task_management_app/services/firebase_service.dart';
import 'package:task_management_app/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await FirebaseAuth.instance.signOut();

  final hiveService = HiveService();
  await hiveService.initializeHive();

  runApp(
    MultiProvider(
      providers: [
        Provider<HiveService>.value(value: hiveService),
        Provider<FirebaseService>(create: (_) => FirebaseService()),
        Provider<AuthService>(create: (_) => AuthService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}
