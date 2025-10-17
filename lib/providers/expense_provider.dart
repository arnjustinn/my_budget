import 'package:flutter/material.dart';
import '../models/expense.dart';

class ExpenseProvider with ChangeNotifier {
  final List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;

  double get totalSpending {
    return _expenses.fold(0.0, (sum, item) => sum + item.amount);
  }

  void addExpense(Expense expense) {
    _expenses.add(expense);
    notifyListeners();
  }
}
