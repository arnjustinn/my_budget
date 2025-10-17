import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../models/expense.dart';

class ExpenseChart extends StatelessWidget {
  final List<Expense> expenses;

  const ExpenseChart({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return const Center(child: Text('No expenses to display.'));
    }

    final Map<String, double> categoryTotals = {};
    for (var expense in expenses) {
      final category = expense.category ?? 'Others';
      categoryTotals[category] = (categoryTotals[category] ?? 0) + expense.amount;
    }

    final List<_ChartData> chartData = [];
    categoryTotals.forEach((category, amount) {
      chartData.add(_ChartData(category, amount));
    });

    return SfCircularChart(
      legend: Legend(
        isVisible: true,
        overflowMode: LegendItemOverflowMode.wrap,
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
            labelPosition: ChartDataLabelPosition.inside,
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          radius: '80%',
          innerRadius: '40%',  // Only valid for DoughnutSeries
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
