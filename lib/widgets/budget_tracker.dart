import 'package:flutter/material.dart';

class BudgetTracker extends StatelessWidget {
  final double totalExpenses;
  final double budgetLimit;
  final VoidCallback onSetBudget;

  const BudgetTracker({
    super.key,
    required this.totalExpenses,
    required this.budgetLimit,
    required this.onSetBudget,
  });

  @override
  Widget build(BuildContext context) {
    // If no budget is set, show a prompt
    if (budgetLimit <= 0) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.teal.shade50,
        child: ListTile(
          leading: const Icon(Icons.savings_outlined, color: Colors.teal),
          title: const Text("No Budget Set"),
          subtitle: const Text("Tap to set a monthly spending goal"),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onSetBudget,
        ),
      );
    }

    // Calculate progress
    double progress = totalExpenses / budgetLimit;
    bool isOverBudget = totalExpenses > budgetLimit;
    Color progressColor = isOverBudget 
        ? Colors.red 
        : (progress > 0.8 ? Colors.orange : Colors.teal);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Monthly Budget",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                InkWell(
                  onTap: onSetBudget,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      "Edit",
                      style: TextStyle(
                        color: Colors.teal.shade700,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress > 1.0 ? 1.0 : progress,
              backgroundColor: Colors.grey[200],
              color: progressColor,
              minHeight: 12,
              borderRadius: BorderRadius.circular(6),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Spent: ₱${totalExpenses.toStringAsFixed(0)}",
                  style: TextStyle(
                    color: progressColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Limit: ₱${budgetLimit.toStringAsFixed(0)}",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            if (isOverBudget)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "⚠️ You have exceeded your budget by ₱${(totalExpenses - budgetLimit).toStringAsFixed(0)}!",
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }
}