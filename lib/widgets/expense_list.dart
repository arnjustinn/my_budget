import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'expense_item.dart';

class ExpenseList extends StatelessWidget {
  final List<Transaction> transactions;
  final void Function(String id)? onDelete;

  const ExpenseList({
    Key? key,
    required this.transactions,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance_wallet_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No transactions yet',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    // Sort by date descending (newest first)
    final sortedTransactions = List<Transaction>.from(transactions)
      ..sort((a, b) => b.date.compareTo(a.date));

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80), // Space for FAB
      itemCount: sortedTransactions.length,
      itemBuilder: (ctx, index) {
        final tx = sortedTransactions[index];
        return ExpenseItem(
          transaction: tx,
          onDelete: onDelete != null ? () => onDelete!(tx.id) : null,
        );
      },
    );
  }
}