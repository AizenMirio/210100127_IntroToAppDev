import 'package:flutter/foundation.dart';

class User {
  String uid;
  String userName;
  String email;
  int age;
  String location;
  String salary;
  List<Map<String, dynamic>> budgetCategories;

  User({
    required this.uid,
    this.userName = 'Anonymous',
    this.email = 'dummy@example.com',
    this.age = 25,
    this.location = 'Anonymous City',
    this.salary = '\$5000',
    List<Map<String, dynamic>>? budgetCategories,
  }) : budgetCategories = budgetCategories ?? [];

  // Getter for user information
  Map<String, dynamic> get userInfo => {
    'User Name': userName,
    'Email': email,
    'Age': age.toString(),
    'Location': location,
    'Salary': salary,
  };

  // Add budget category
  void addBudgetCategory(Map<String, dynamic> category) {
    budgetCategories.add(category);
  }

  // Remove budget category by name
  void removeBudgetCategory(String name) {
    budgetCategories.removeWhere((category) => category['name'] == name);
  }
}
