import 'package:flutter/material.dart';

class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String? category;

  Expense({
    String? id, // Optional, auto-generated if not provided
    required this.title,
    required this.amount,
    required this.date,
    this.category,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  // Convert Expense object to Map (for saving in local storage/DB)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
    };
  }

  // Create Expense object from Map (for loading from storage/DB)
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'], // Uses provided ID from storage
      title: map['title'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      category: map['category'],
    );
  }

  // For UI category icons (optional)
  static IconData getCategoryIcon(String? category) {
    switch (category) {
      case 'Food':
        return Icons.restaurant;
      case 'Transport':
        return Icons.directions_bus;
      case 'Bills':
        return Icons.receipt;
      case 'Shopping':
        return Icons.shopping_bag;
      default:
        return Icons.attach_money;
    }
  }
}
