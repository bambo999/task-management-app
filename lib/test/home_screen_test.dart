// File: tests/home_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../screens/home_screen.dart';

void main() {
  testWidgets('HomeScreen displays tasks', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(MaterialApp(home: HomeScreen()));

    // Verify that the floating action button exists
    expect(find.byType(FloatingActionButton), findsOneWidget);

    // Verify that the task list is displayed
    expect(find.byType(ListView), findsOneWidget);
  });
}