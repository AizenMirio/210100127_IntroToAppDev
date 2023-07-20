import 'package:flutter/material.dart';
import 'Pages/home.dart';
import 'package:assignment_week_2/Pages/Expense.dart';

void main() => runApp(MaterialApp(
    initialRoute: '/home',
    routes: {
      '/home': (context) => Home(),
      '/expense': (context) => ExpenseScreen(),
    }
  ),
);


