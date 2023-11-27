import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:expense_tracker/models/expense.dart';
//import 'package:flutter/rendering.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }
void _showDialog(){
if(Platform.isIOS){

showCupertinoDialog(context: context, builder: (cxt) => CupertinoAlertDialog(

title: const Text('Invalid Input'),
content: const Text(
'Please make sure a valid amount, date, category and tile is entered'),
actions: [
  TextButton(onPressed: (){
    Navigator.pop(context);                          //used to close the dialog
  }, child: const Text('OK'))
],
 ));
}
 else{
 showDialog(context: context,
  builder: (cxt) => AlertDialog(
title: const Text('Invalid Input'),
content: const Text(
'Please make sure a valid amount, date, category and tile is entered'),
actions: [
  TextButton(onPressed: (){
    Navigator.pop(context);                          //used to close the dialog
  }, child: const Text('OK'))
],
 ) 
 );
}
}

  void _sumitExpenseData(){
    final enteredAmount=  double.tryParse(_amountController.text);      //tryparse('hello')==>null   tryparse('12.23)==>12.23
  final amountIsInvalid = enteredAmount == null || enteredAmount <=0;
 if(_titleController.text.trim().isEmpty || amountIsInvalid || _selectedDate ==null ){                 //trim is used to remove extra white spaces at the begning or end
 
 _showDialog();
 return;
 }    

 widget.onAddExpense(Expense(title: _titleController.text,
  amount: enteredAmount,
   date: _selectedDate!,                           //! is used to tell dart this value is not null we are sure
    category: _selectedCategory,
    ),
    );             
  Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
  return LayoutBuilder(builder: (ctx,constraints) {
    final width = constraints.maxWidth;

return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),               //to avoid sight problems frm camera and other stuff
          child: Column(
            children: [
              if(width >=600)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Expanded(child: 
                TextField(
                controller: _titleController,
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Title'),
                ),
              ),
                ),
              const SizedBox(width: 24),
              Expanded(
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        prefixText: '₹ ',
                        label: Text('Amount'),
                      ),
                    ),
                  ),
              ],
              )
              else
              TextField(
                controller: _titleController,
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Title'),
                ),
              ),
              if(width >=600)
              Row(children: [
                DropdownButton(
                    value: _selectedCategory,
                    items: Category.values
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Text(
                              category.name.toUpperCase(),
                            ),
                          ),
                        ).toList(),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                  const SizedBox(width: 24),
                Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _selectedDate == null
                              ? 'No date selected'
                              : formatter.format(_selectedDate!),
                        ),
                        IconButton(
                          onPressed: _presentDatePicker,
                          icon: const Icon(
                            Icons.calendar_month,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],)
              else
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        prefixText: '₹ ',
                        label: Text('Amount'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _selectedDate == null
                              ? 'No date selected'
                              : formatter.format(_selectedDate!),
                        ),
                        IconButton(
                          onPressed: _presentDatePicker,
                          icon: const Icon(
                            Icons.calendar_month,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if(width >=600)
              Row(children: [
                const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: _sumitExpenseData,
                    child: const Text('Save Expense'),
                  ),
              ],)
              else
              Row(
                children: [
                  DropdownButton(
                    value: _selectedCategory,
                    items: Category.values
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Text(
                              category.name.toUpperCase(),
                            ),
                          ),
                        ).toList(),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: _sumitExpenseData,
                    child: const Text('Save Expense'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  })
  ;

    
  }
}