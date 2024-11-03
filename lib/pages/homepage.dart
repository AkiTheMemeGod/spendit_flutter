import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendit/bar_graph/bar_graph.dart';
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

  Future<Map<int, double>>? _monthlytotalfuture;

  @override
  void initState() {
    Provider.of<ExpenseDatabase>(context, listen: false).readExpenses();
    refreshgraphdata();
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

  void refreshgraphdata() {
    _monthlytotalfuture = Provider.of<ExpenseDatabase>(context, listen: false)
        .calculatemonthlytotals();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseDatabase>(builder: (context, value, child) {
      int startmonth = value.getStartmonth();
      int startyear = value.getStartyear();
      int currentmonth = DateTime.now().month;
      int currentyear = DateTime.now().year;

      int monthcount =
          calccurrentmonth(startyear, startmonth, currentyear, currentmonth);

      return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: openNewExpenseBox,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 250,
                child: FutureBuilder(
                    future: _monthlytotalfuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        final monthlytotals = snapshot.data ?? {};

                        List<double> monthlysummary = List.generate(
                            monthcount,
                            (index) =>
                                monthlytotals[startmonth + index] ?? 0.0);

                        return MyBarGraph(
                            monthlysummary: monthlysummary,
                            startmonth: startmonth);
                      } else {
                        return const Text("Loading..");
                      }
                    }),
              ),
              Expanded(
                child: ListView.builder(
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
            ],
          ),
        ),
      );
    });
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
