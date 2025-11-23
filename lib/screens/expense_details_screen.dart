import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'package:intl/intl.dart';

class ExpenseDetailsScreen extends StatelessWidget {
  final Transaction expense; // Rename inside this class to keep logic clear, but type is Transaction

  const ExpenseDetailsScreen({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    final isIncome = expense.type == TransactionType.income;
    final color = isIncome ? Colors.green : Colors.red;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction Details"),
        backgroundColor: isIncome ? Colors.green : Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Transaction.getCategoryIcon(expense.category),
                        size: 32,
                        color: color,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            expense.title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            isIncome ? "Income" : "Expense",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 40),
                _buildDetailRow(
                  Icons.attach_money, 
                  "Amount", 
                  "₱ ${expense.amount.toStringAsFixed(2)}",
                  color
                ),
                const SizedBox(height: 20),
                _buildDetailRow(
                  Icons.category, 
                  "Category", 
                  expense.category
                ),
                const SizedBox(height: 20),
                _buildDetailRow(
                  Icons.calendar_today, 
                  "Date", 
                  DateFormat.yMMMMd().format(expense.date)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, [Color? valueColor]) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[600], size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
            Text(
              value, 
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.w600,
                color: valueColor ?? Colors.black87
              )
            ),
          ],
        ),
      ],
    );
  }
}