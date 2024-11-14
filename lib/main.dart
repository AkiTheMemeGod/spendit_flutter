import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendit/auth/auth_gate.dart';
import 'package:spendit/database/expense_database.dart';
import 'package:spendit/pages/homepage.dart';
import 'package:spendit/pages/loginpage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
      url: "https://yvyjdikfwbeizyygqphb.supabase.co",
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl2eWpkaWtmd2JlaXp5eWdxcGhiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE1Njk2NzgsImV4cCI6MjA0NzE0NTY3OH0.AmbV8VeUvTDd8K6kIlo4fesJyLYuGMcjnjddogHBOvw");

  WidgetsFlutterBinding.ensureInitialized();

  await ExpenseDatabase.initialize();
  runApp(ChangeNotifierProvider(
    create: (context) => ExpenseDatabase(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}
