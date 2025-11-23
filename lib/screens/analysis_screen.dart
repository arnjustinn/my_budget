import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../widgets/expense_chart.dart';

class AnalysisScreen extends StatelessWidget {
  final List<Transaction> transactions;

  const AnalysisScreen({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Expense Analysis'),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ExpenseChart(transactions: transactions),
          ),
        ),
      ),
    );
  }
}