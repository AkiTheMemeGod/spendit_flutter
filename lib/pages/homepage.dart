import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendit/comps/mylisttile.dart';
import 'package:spendit/database/expense_database.dart';
import 'package:spendit/helpers/helper.dart';
import 'package:spendit/model/expense.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController name = TextEditingController();
  TextEditingController amt = TextEditingController();

  @override
  void initState() {
    Provider.of<ExpenseDatabase>(context, listen: false).readExpenses();
    super.initState();
  }

  void openNewExpenseBox() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("New Expense"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    autocorrect: true,
                    controller: name,
                    decoration: InputDecoration(hintText: "Expense name"),
                  ),
                  TextField(
                    controller: amt,
                    decoration: InputDecoration(hintText: "Amount"),
                  )
                ],
              ),
              actions: [savebutton(), cancelbutton()],
            ));
  }

  void openEditBox(Expense expense) {
    String existname = expense.name;
    String existamt = expense.amount.toString();

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Edit Expense"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    autocorrect: true,
                    controller: name,
                    decoration: InputDecoration(hintText: existname),
                  ),
                  TextField(
                    controller: amt,
                    decoration: InputDecoration(hintText: existamt),
                  )
                ],
              ),
              actions: [editexpensebutton(expense), cancelbutton()],
            ));
  }

  void openDeleteBox(Expense expense) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Delete Expense"),
              actions: [deletebutton(expense.id), cancelbutton()],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseDatabase>(
      builder: (context, value, child) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: openNewExpenseBox,
          child: Icon(Icons.add),
        ),
        body: ListView.builder(
            itemCount: value.allExpense.length,
            itemBuilder: (context, index) {
              Expense individualExpense = value.allExpense[index];

              return Mylisttile(
                title: individualExpense.name,
                trailing: formatAmount(individualExpense.amount),
                onedit: (context) => openEditBox(individualExpense),
                ondelete: (context) => openDeleteBox(individualExpense),
              );
            }),
      ),
    );
  }

  Widget cancelbutton() {
    return MaterialButton(
      onPressed: () {
        Navigator.pop(context);

        name.clear();
        amt.clear();
      },
      child: Text("Cancel"),
    );
  }

  Widget savebutton() {
    return MaterialButton(
      onPressed: () async {
        if (name.text.isNotEmpty && amt.text.isNotEmpty) {
          Navigator.pop(context);
          Expense newexpense = Expense(
              name: name.text,
              amount: convertStringtoDouble(amt.text),
              date: DateTime.now());

          await context.read<ExpenseDatabase>().createNewExpense(newexpense);

          name.clear();
          amt.clear();
        }
      },
      child: const Text("Save"),
    );
  }

  Widget editexpensebutton(Expense expense) {
    return MaterialButton(
      onPressed: () async {
        if (name.text.isNotEmpty || amt.text.isNotEmpty) {
          Navigator.pop(context);

          Expense updatedExpense = Expense(
              name: name.text.isNotEmpty ? name.text : expense.name,
              amount: amt.text.isNotEmpty
                  ? convertStringtoDouble(amt.text)
                  : expense.amount,
              date: DateTime.now());

          int existingId = expense.id;

          await context
              .read<ExpenseDatabase>()
              .update(existingId, updatedExpense);
        }
      },
      child: Text("Update"),
    );
  }

  Widget deletebutton(int id) {
    return MaterialButton(
      onPressed: () async {
        Navigator.pop(context);

        await context.read<ExpenseDatabase>().delete(id);
      },
      child: Text("Delete"),
    );
  }
}
