import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../widgets/summary_card.dart';
import '../widgets/expense_list.dart';
import '../widgets/budget_tracker.dart'; // Import the new widget
import 'add_expense_screen.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart'; // Import Notification Service

import 'analysis_screen.dart';
import 'account_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Transaction> _transactions = [];
  double _monthlyBudget = 0.0;
  final StorageService _storageService = StorageService();
  final NotificationService _notificationService = NotificationService(); // Instance

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final loadedData = await _storageService.loadTransactions();
    final savedBudget = await _storageService.loadBudgetLimit();
    
    setState(() {
      _transactions.clear();
      _transactions.addAll(loadedData);
      _monthlyBudget = savedBudget;
    });
  }

  Future<void> _saveData() async {
    await _storageService.saveTransactions(_transactions);
  }

  Future<void> _saveBudget(double amount) async {
    setState(() {
      _monthlyBudget = amount;
    });
    await _storageService.saveBudgetLimit(amount);
  }

  void _addTransaction(Transaction transaction) {
    setState(() {
      _transactions.add(transaction);
    });
    _saveData();
    _checkBudgetThresholds(); // Check budget after adding
  }

  void _checkBudgetThresholds() {
    if (_monthlyBudget <= 0) return;

    final totalExpenses = _totalExpenses;
    final ratio = totalExpenses / _monthlyBudget;

    if (ratio >= 1.0) {
      _notificationService.showNotification(
        id: 1,
        title: '⚠️ Budget Limit Exceeded!',
        body: 'You have spent ₱${totalExpenses.toStringAsFixed(0)}, exceeding your limit of ₱${_monthlyBudget.toStringAsFixed(0)}.',
      );
    } else if (ratio >= 0.8) {
      _notificationService.showNotification(
        id: 2,
        title: 'Budget Alert',
        body: 'You have used ${(ratio * 100).toStringAsFixed(0)}% of your monthly budget.',
      );
    }
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((item) => item.id == id);
    });
    _saveData();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showSetBudgetDialog() {
    final TextEditingController controller = TextEditingController(
      text: _monthlyBudget > 0 ? _monthlyBudget.toStringAsFixed(2) : '',
    );

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Set Monthly Budget'),
          content: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              prefixText: '₱ ',
              hintText: 'Enter amount',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(controller.text);
                if (amount != null && amount > 0) {
                  _saveBudget(amount);
                  Navigator.pop(ctx);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  double get _totalExpenses {
    return _transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  List<Widget> get _pages => [
        _buildHomeTab(),
        AnalysisScreen(transactions: _transactions),
        const AccountScreen(),
      ];

  Widget _buildHomeTab() {
    return Column(
      children: [
        SummaryCard(transactions: _transactions),
        BudgetTracker(
          totalExpenses: _totalExpenses,
          budgetLimit: _monthlyBudget,
          onSetBudget: _showSetBudgetDialog,
        ),
        Expanded(
          child: ExpenseList(
            transactions: _transactions,
            onDelete: _deleteTransaction,
          ),
        ),
      ],
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
        elevation: 0,
      ),
      body: _pages[_selectedIndex],
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              backgroundColor: Colors.teal,
              child: const Icon(Icons.add),
              onPressed: () async {
                final newTransaction = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddExpenseScreen(),
                  ),
                );
                if (newTransaction != null && newTransaction is Transaction) {
                  _addTransaction(newTransaction);
                }
              },
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
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