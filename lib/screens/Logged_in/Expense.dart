import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:assignment_week_2/models/user.dart';
import 'package:provider/provider.dart';

class Expense {
  String id; // Add this field to hold the document ID from Firestore
  String categoryName;
  String amount;
  DateTime timestamp;

  Expense({
    required this.id, // Update the constructor to include the ID
    required this.categoryName,
    required this.amount,
    required this.timestamp,
  });

  Expense.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.id, // Initialize the ID field with the document ID
        categoryName = snapshot['categoryName'],
        amount = snapshot['amount'],
        timestamp = (snapshot['timestamp'] as Timestamp).toDate();
}

class ExpenseScreen extends StatefulWidget {
  final User? user; // Change User to User?
  ExpenseScreen({Key? key, this.user}) : super(key: key);

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _currentUser;
  List<Expense> expenses = [];

  void addExpense(String categoryName, String amount) async {
    try {
      // Access the current user's UID
      String? uid = _currentUser?.uid;

      if (uid != null) {
        // Create a reference to the "expenses" collection under the user's document
        CollectionReference expensesRef =
        _firestore.collection('users').doc(uid).collection('expenses');

        // Add the new expense data as a new document in the "expenses" collection
        await expensesRef.add({
          'categoryName': categoryName,
          'amount': amount,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Show a success message (optional)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Expense added successfully!')),
        );

        // Fetch the updated expenses from Firestore
        fetchExpenses();
      }
    } catch (e) {
      // Show an error message (optional)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error adding expense. Please try again later.')),
      );
      print(e); // Print the error for debugging (optional)
    }
  }

  void deleteCategory(int index) async {
    try {
      String? uid = _currentUser?.uid;

      if (uid != null) {
        CollectionReference expensesRef = _firestore.collection('users').doc(uid).collection('expenses');
        await expensesRef.doc(expenses[index].id).delete();

        setState(() {
          expenses.removeAt(index);
          updateTotalExpense();
        });
      }
    } catch (e) {
      print('Error deleting expense: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting expense. Please try again later.')),
      );
    }
  }

  void addCategory(String name, String amount) {
    setState(() {
      expenses.add(
        Expense(
          id: '', // The ID will be assigned by Firestore when we add the document
          categoryName: name,
          amount: amount,
          timestamp: DateTime.now(),
        ),
      );
      updateTotalExpense();
    });
  }

  void updateTotalExpense() {
    int totalExpense = expenses.fold(0, (sum, category) {
      int parsedAmount = int.tryParse(category.amount.replaceAll('\$', '') ?? '0') ?? 0;
      return sum + parsedAmount;
    });
    setState(() {
      categoriesTotalExpense = totalExpense;
    });
  }

  int categoriesTotalExpense = 0;

  String getMaxExpenseCategory() {
    if (expenses.isEmpty) {
      return 'No expenses';
    }

    Expense maxExpense = expenses.reduce((currMax, expense) {
      int currMaxAmount = int.tryParse(currMax.amount.replaceAll('\$', '') ?? '0') ?? 0;
      int expenseAmount = int.tryParse(expense.amount.replaceAll('\$', '') ?? '0') ?? 0;
      return currMaxAmount >= expenseAmount ? currMax : expense;
    });

    return maxExpense.categoryName;
  }

  int calculateAvailableBalance() {
    int spendingLimit = _budget;
    int totalExpense = expenses.fold(0, (sum, expense) {
      int parsedAmount = int.tryParse(expense.amount.replaceAll('\$', '') ?? '0') ?? 0;
      return sum + parsedAmount;
    });
    return spendingLimit - totalExpense;
  }

  String getBalanceMessage() {
    int availableBalance = calculateAvailableBalance();

    if (availableBalance < 0) {
      return 'Critical: Spending limit exceeded';
    } else if (availableBalance < 500) {
      return 'Low Balance: You have only \$${availableBalance.toString()} left';
    } else {
      return 'Available Balance: \$${availableBalance.toString()}';
    }
  }


  int _budget = 4000; // Default budget value

  void setBudget(int newBudget) {
    setState(() {
      _budget = newBudget;
      updateTotalExpense(); // Update the total expense display based on the new budget
    });
  }

  void _showSetBudgetDialog(BuildContext context) {
    int newBudget = _budget;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Set Budget'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'New Budget'),
                onChanged: (value) {
                  newBudget = int.tryParse(value) ?? _budget;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setBudget(newBudget);
                Navigator.pop(context);
              },
              child: const Text('Set'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // Calculate and set the initial total expense based on sample data
    _currentUser = widget.user;
    fetchExpenses();
  }

  void fetchExpenses() async {
    String? uid = _currentUser?.uid;
    if (uid != null) {
      CollectionReference expensesRef = _firestore.collection('users').doc(uid).collection('expenses');
      QuerySnapshot querySnapshot = await expensesRef.get();
      List<Expense> fetchedExpenses = querySnapshot.docs.map((doc) => Expense.fromSnapshot(doc)).toList();

      setState(() {
        expenses = fetchedExpenses;
        updateTotalExpense();
      });
    }
  }


  void _showAddCategoryDialog(BuildContext context) {
    String categoryName = '';
    String amount = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Expense Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Category Name'),
                onChanged: (value) {
                  categoryName = value;
                },
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(labelText: 'Expense Amount'),
                onChanged: (value) {
                  amount = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (categoryName.isNotEmpty && amount.isNotEmpty) {
                  // Save expense to Firestore
                  addExpense(categoryName, amount);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Screen'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/home');
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Expense Total Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.blue,
            ),
            child: Text(
              'Expense Total: \$${categoriesTotalExpense.toString()}', // Display the total expense
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _showSetBudgetDialog(context);
            },
            child: const Text('Set Budget'),
          ),

          // Categories List
          for (int i = 0; i < expenses.length; i++)
            CategoryRow(
              categoryName: expenses[i].categoryName,
              amount: expenses[i].amount,
              onDelete: () {
                deleteCategory(i);
              },
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Category with Max Expense: ${getMaxExpenseCategory()}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              getBalanceMessage(),
              style: TextStyle(
                fontSize: 18,
                color: calculateAvailableBalance() < 0 ? Colors.red : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddCategoryDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CategoryRow extends StatelessWidget {
  final String categoryName;
  final String amount;
  final VoidCallback onDelete;

  CategoryRow({
    required this.categoryName,
    required this.amount,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              categoryName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              amount,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
