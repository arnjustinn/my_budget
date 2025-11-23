import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';

class ExportService {
  /// Converts transactions to CSV and triggers a share dialog
  Future<void> exportToCSV(List<Transaction> transactions) async {
    if (transactions.isEmpty) {
      throw Exception("No data to export.");
    }

    // 1. Create CSV Data Header
    List<List<dynamic>> rows = [];
    rows.add([
      "ID",
      "Date",
      "Type",
      "Category",
      "Title",
      "Amount",
    ]);

    // 2. Add Rows
    for (var t in transactions) {
      rows.add([
        t.id,
        DateFormat('yyyy-MM-dd').format(t.date),
        t.type == TransactionType.income ? 'Income' : 'Expense',
        t.category,
        t.title,
        t.amount,
      ]);
    }

    // 3. Convert to CSV String
    String csvData = const ListToCsvConverter().convert(rows);

    // 4. Get Temporary Directory
    final directory = await getTemporaryDirectory();
    final path = "${directory.path}/mybudget_export_${DateTime.now().millisecondsSinceEpoch}.csv";
    
    // 5. Write to File
    final File file = File(path);
    await file.writeAsString(csvData);

    // 6. Share File
    await Share.shareXFiles(
      [XFile(path)],
      text: 'Here is my budget transaction history.',
      subject: 'MyBudget Data Export',
    );
  }
}