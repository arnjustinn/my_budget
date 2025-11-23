import 'package:flutter/material.dart';

enum TransactionType { income, expense }

class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String category;
  final TransactionType type;

  Transaction({
    String? id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.type,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  // Convert Transaction object to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
      'type': type.toString(), // Store enum as string
    };
  }

  // Create Transaction object from Map
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      category: map['category'] ?? 'Others',
      type: map['type'] == 'TransactionType.income' 
          ? TransactionType.income 
          : TransactionType.expense,
    );
  }

  // Helper to get icons based on category
  static IconData getCategoryIcon(String category) {
    switch (category) {
      // Expense Categories
      case 'Food': return Icons.restaurant;
      case 'Transport': return Icons.directions_bus;
      case 'Bills': return Icons.receipt;
      case 'Shopping': return Icons.shopping_bag;
      // Income Categories
      case 'Salary': return Icons.work;
      case 'Investment': return Icons.trending_up;
      case 'Gift': return Icons.card_giftcard;
      default: return Icons.category;
    }
  }
}