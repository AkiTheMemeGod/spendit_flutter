import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spendit/model/expense.dart';

class ExpenseDatabase extends ChangeNotifier {
  static late Isar isar;
  List<Expense> _allExpenses = [];

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([ExpenseSchema], directory: dir.path);
  }

  List<Expense> get allExpense => _allExpenses;

  //CRUD

  Future<void> createNewExpense(Expense newexpense) async {
    await isar.writeTxn(() => isar.expenses.put(newexpense));

    readExpenses();
  }

  Future<void> readExpenses() async {
    List<Expense> all_expenses = await isar.expenses.where().findAll();
    _allExpenses.clear();
    _allExpenses.addAll(all_expenses);

    notifyListeners();
  }

  Future<void> update(int id, Expense updatedExpense) async {
    updatedExpense.id = id;

    await isar.writeTxn(() => isar.expenses.put(updatedExpense));

    await readExpenses();
  }

  Future<void> delete(int id) async {
    await isar.writeTxn(() => isar.expenses.delete(id));

    await readExpenses();
  }

  Future<Map<int, double>> calculatemonthlytotals() async {
    await readExpenses();

    Map<int, double> monthlytotals = {};

    for (var expenses in _allExpenses) {
      int month = expenses.date.month;

      if (!monthlytotals.containsKey(month)) {
        monthlytotals[month] = 0;
      }

      monthlytotals[month] = monthlytotals[month]! + expenses.amount;
    }

    return monthlytotals;
  }

  int getStartmonth() {
    if (_allExpenses.isEmpty) {
      return DateTime.now().month;
    }

    _allExpenses.sort(
      (a, b) => a.date.compareTo(b.date),
    );

    return _allExpenses.first.date.month;
  }

  int getStartyear() {
    if (_allExpenses.isEmpty) {
      return DateTime.now().year;
    }

    _allExpenses.sort(
      (a, b) => a.date.compareTo(b.date),
    );

    return _allExpenses.first.date.year;
  }
}
