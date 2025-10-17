import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense.dart';

class StorageService {
  static const String _expensesKey = 'expenses_list';

  /// Save expenses to local storage
  Future<void> saveExpenses(List<Expense> expenses) async {
    final prefs = await SharedPreferences.getInstance();
    final expenseListJson =
        expenses.map((e) => jsonEncode(e.toMap())).toList();
    await prefs.setStringList(_expensesKey, expenseListJson);
  }

  /// Load expenses from local storage
  Future<List<Expense>> loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final storedList = prefs.getStringList(_expensesKey) ?? [];

    return storedList
        .map((expenseJson) =>
            Expense.fromMap(jsonDecode(expenseJson) as Map<String, dynamic>))
        .toList();
  }

  /// Clear all saved expenses
  Future<void> clearExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_expensesKey);
  }
}
