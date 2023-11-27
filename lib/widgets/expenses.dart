//import 'package:flutter/cupertino.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget{
const Expenses({super.key});

@override
  State<Expenses> createState() {
   return _ExpensesState();                                    // instance of our expense state
  }
}


class _ExpensesState extends State<Expenses> {
final List<Expense> _registeredExpenses=[
  Expense(title: 'Flutter course',
   amount: 1099, 
   date: DateTime.now(), 
   category:Category.work,),
Expense(title: 'movie',
   amount: 300, 
   date: DateTime.now(), 
   category:Category.leisure,),
];

void _openAddExpenseOverlay(){
showModalBottomSheet(
  useSafeArea: true,
isScrollControlled: true,                 //helps to the full screen to avoid keyboard wala problem
context: context,
 builder: (cxt) =>NewExpense(
  onAddExpense:_addExpense),
 );
}
 
 void _addExpense(Expense expense){
  setState(() {
    _registeredExpenses.add(expense);
  });
 }

void _removeExpense(Expense expense){
  final expenseIndex=_registeredExpenses.indexOf(expense);
setState(() {
  _registeredExpenses.remove(expense);
});
ScaffoldMessenger.of(context).clearSnackBars();                   //undo kaafi late mai aa rha tha jab humlog expense htaa rhe the toh isse turant apppear hota h
ScaffoldMessenger.of(context).showSnackBar(SnackBar(
duration: const Duration(seconds: 3),
content: const Text('Expense deleted'),
action: SnackBarAction(label: 'Undo',
 onPressed: () {
  setState(() {
    _registeredExpenses.insert(expenseIndex, expense);                   //insert is all used to add elements in list
  });
 }),
),
);

}
  @override
  Widget build(BuildContext context) {
 final width= MediaQuery.of(context).size.width;

Widget mainContent = const Center(child: Text('No expenses found.Start adding some!!'),
);
if(_registeredExpenses.isNotEmpty){                        //method offered by flutter to check if the list is empty or not
mainContent=ExpensesList(expenses:_registeredExpenses,
    onRemoveExpense: _removeExpense,
    );
}
   return Scaffold(
  appBar: AppBar(
    title: const Text('Flutter Expense Tracker'),
    actions: [                          // this is used for buttom
  IconButton(onPressed: _openAddExpenseOverlay,
   icon: const Icon(Icons.add)
   )
    ],
  ),


  body: width <600 ? Column(children: [
   Chart(expenses: _registeredExpenses),
    Expanded(child: mainContent,   // column and inside it is list (expenseslist) therefore list inside list for that expanded is used
    ), 
   ]
   ): Row(children: [
    Expanded(child:
    Chart(expenses: _registeredExpenses),
    ),
    Expanded(child: mainContent,   // column and inside it is list (expenseslist) therefore list inside list for that expanded is used
    ), 
   ],)
   );
  }
}