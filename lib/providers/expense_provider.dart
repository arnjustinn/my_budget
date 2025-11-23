import 'package:flutter/material.dart';
import '../models/expense.dart'; // This file contains the Transaction class

class ExpenseProvider with ChangeNotifier {
  final List<Transaction> _expenses = [];

  List<Transaction> get expenses => _expenses;

  double get totalSpending {
    // Calculate total only for expense types if you want strictly "spending"
    return _expenses
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  void addExpense(Transaction transaction) {
    _expenses.add(transaction);
    notifyListeners();
  }
}