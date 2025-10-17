import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../widgets/expense_chart.dart';

class AnalysisScreen extends StatelessWidget {
  final List<Expense> expenses;

  const AnalysisScreen({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis Report'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ExpenseChart(expenses: expenses),
      ),
    );
  }
}
