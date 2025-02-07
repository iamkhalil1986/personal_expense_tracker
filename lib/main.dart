import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/core/theme.dart';
import 'package:personal_expense_tracker/view_expenses/ui/view_expenses_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expense Tracker',
      theme: ThemeData(colorScheme: MaterialTheme.lightScheme()),
      home: const ViewExpensesWidget(),
    );
  }
}
