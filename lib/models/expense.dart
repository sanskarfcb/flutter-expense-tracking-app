//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final formatter=DateFormat.yMd();                    // yMd simply creates formatter object which we can use to format dates

const uuid= Uuid();
enum Category { food, travel, leisure, work}

const categoryIcons={                             // map is used here enum is key and icons are values
Category.food : Icons.lunch_dining,
Category.travel: Icons.flight_takeoff,
Category.leisure:Icons.movie,
Category.work:Icons.work,
};

class Expense{
Expense({
required this.title,
required this.amount,
required this.date,
required this.category,
}) : id=uuid.v4() ;     //intializer lists used here.v4 is used for giving unique string id
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return formatter.format(date);
  }
}

class ExpenseBucket{
const  ExpenseBucket({
  required this.category, 
  required this.expenses,
  });

  ExpenseBucket.forCategory(List<Expense> allExpense , this.category)
  : expenses =
  allExpense.where((expense) => 
  expense.category==category,
  ).toList();


final Category category;
final List<Expense>expenses;
 
 double get totalExpenses{              //ultility getter
  double sum = 0;
  
for(final expense in expenses){
  sum=sum + expense.amount;

}
return sum;

 }

}