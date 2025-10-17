import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../widgets/summary_card.dart';
import '../widgets/expense_list.dart';
import 'add_expense_screen.dart';
import '../services/storage_service.dart';

import 'analysis_screen.dart';
import 'account_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Expense> _expenses = [];
  final StorageService _storageService = StorageService();

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    final loadedExpenses = await _storageService.loadExpenses();
    setState(() {
      _expenses.clear();
      _expenses.addAll(loadedExpenses);
    });
  }

  Future<void> _saveExpenses() async {
    await _storageService.saveExpenses(_expenses);
  }

  void _addExpense(Expense expense) {
    setState(() {
      _expenses.add(expense);
    });
    _saveExpenses();
  }

  void _deleteExpense(String id) {
    setState(() {
      _expenses.removeWhere((expense) => expense.id == id);
    });
    _saveExpenses();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // The 3 tab pages
  List<Widget> get _pages => [
        _buildHomeTab(),
        AnalysisScreen(expenses: _expenses),
        const AccountScreen(),
      ];

  Widget _buildHomeTab() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          SummaryCard(expenses: _expenses),
          const SizedBox(height: 12),
          Expanded(
            child: _expenses.isEmpty
                ? Center(
                    child: Text(
                      'No expenses yet.\nTap + to add one!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  )
                : ExpenseList(
                    expenses: _expenses,
                    onDelete: _deleteExpense,
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'My Budget',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 2,
      ),
      body: _pages[_selectedIndex],
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              backgroundColor: Colors.teal,
              child: const Icon(Icons.add),
              onPressed: () async {
                final newExpense = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddExpenseScreen(),
                  ),
                );
                if (newExpense != null && newExpense is Expense) {
                  _addExpense(newExpense);
                }
              },
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Analysis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
