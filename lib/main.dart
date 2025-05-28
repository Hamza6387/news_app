import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/hive_database_manager.dart';
import 'screens/splash_screen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  final hiveDatabaseManager = HiveDatabaseManager.instance;
  await hiveDatabaseManager.initialize();
  
  runApp(

    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News Buzz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Modern teal/green theme for the app - more vibrant than basic blue
        primarySwatch: Colors.teal,
        primaryColor: Colors.teal[700],
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.teal[700],
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal[700],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.teal[700]!),
          ),
        ),
        // cardTheme: CardTheme(
        //   elevation: 2,
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(12),
        //   ),
        // ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.teal[700],
          foregroundColor: Colors.white,
        ),
      ),
      // Start with splash screen to check login status
      home: const SplashScreen(),
    );
  }
}
