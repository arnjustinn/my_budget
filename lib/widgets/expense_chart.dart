import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../models/expense.dart';

class ExpenseChart extends StatelessWidget {
  final List<Transaction> transactions;

  const ExpenseChart({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    // Filter only expenses for the chart
    final expenses = transactions.where((t) => t.type == TransactionType.expense).toList();

    if (expenses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pie_chart_outline, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text('No expenses to analyze yet.'),
          ],
        ),
      );
    }

    final Map<String, double> categoryTotals = {};
    for (var tx in expenses) {
      categoryTotals[tx.category] = (categoryTotals[tx.category] ?? 0) + tx.amount;
    }

    final List<_ChartData> chartData = [];
    categoryTotals.forEach((category, amount) {
      chartData.add(_ChartData(category, amount));
    });

    return SfCircularChart(
      legend: Legend(
        isVisible: true,
        overflowMode: LegendItemOverflowMode.wrap,
        position: LegendPosition.bottom,
      ),
      series: <DoughnutSeries<_ChartData, String>>[
        DoughnutSeries<_ChartData, String>(
          dataSource: chartData,
          xValueMapper: (_ChartData data, _) => data.category,
          yValueMapper: (_ChartData data, _) => data.amount,
          dataLabelMapper: (_ChartData data, _) =>
              '${data.category}\n₱${data.amount.toStringAsFixed(0)}',
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.outside,
            textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          radius: '70%',
          innerRadius: '50%',
          explode: true,
        ),
      ],
    );
  }
}

class _ChartData {
  final String category;
  final double amount;

  _ChartData(this.category, this.amount);
}