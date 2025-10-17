import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'expense_item.dart';

class ExpenseList extends StatelessWidget {
  final List<Expense> expenses;
  final void Function(String id)? onDelete;

  const ExpenseList({
    Key? key,
    required this.expenses,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return const Center(
        child: Text(
          'No expenses yet!',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      );
    }

    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, index) {
        final expense = expenses[index];
        return ExpenseItem(
          expense: expense,
          onDelete: onDelete != null ? () => onDelete!(expense.id) : null,
        );
      },
    );
  }
}
