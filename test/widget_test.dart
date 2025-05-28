// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:news_buzz/main.dart';

void main() {
  group('News Buzz App Tests', () {
    testWidgets('App should start with splash screen', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());

      // Verify that splash screen elements are present
      expect(find.text('News Buzz'), findsOneWidget);
      expect(find.text('Stay Updated with Latest News'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('App should show login screen after splash', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());

      // Wait for splash screen to finish (2 seconds + some buffer)
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify that login screen elements are present
      expect(find.text('Welcome to News Buzz'), findsOneWidget);
      expect(find.text('Sign in to continue'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2)); // Email and password fields
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('Login form should validate empty fields', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());

      // Wait for login screen
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Find and tap the login button without entering credentials
      final loginButton = find.text('Login');
      await tester.tap(loginButton);
      await tester.pump();

      // Verify validation messages appear
      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
    });
  });
}
