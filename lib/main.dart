import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendit/database/expense_database.dart';
import 'package:spendit/pages/homepage.dart';

void main() async {
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
      home: Homepage(),
    );
  }
}
