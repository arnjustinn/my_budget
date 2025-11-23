import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense.dart';

class StorageService {
  static const String _expensesKey = 'expenses_list';
  static const String _budgetKey = 'monthly_budget_limit';

  /// Save transactions to local storage
  Future<void> saveTransactions(List<Transaction> transactions) async {
    final prefs = await SharedPreferences.getInstance();
    final listJson =
        transactions.map((e) => jsonEncode(e.toMap())).toList();
    await prefs.setStringList(_expensesKey, listJson);
  }

  /// Load transactions from local storage
  Future<List<Transaction>> loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final storedList = prefs.getStringList(_expensesKey) ?? [];

    return storedList
        .map((itemJson) =>
            Transaction.fromMap(jsonDecode(itemJson) as Map<String, dynamic>))
        .toList();
  }

  /// Save Monthly Budget Limit
  Future<void> saveBudgetLimit(double amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_budgetKey, amount);
  }

  /// Load Monthly Budget Limit
  Future<double> loadBudgetLimit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_budgetKey) ?? 0.0;
  }

  /// Clear all saved data
  Future<void> clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_expensesKey);
    await prefs.remove(_budgetKey);
  }
}