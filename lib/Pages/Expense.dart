import 'package:flutter/material.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  // Sample data for categories
  List<Map<String, String>> categories = [
    {'name': 'Food', 'amount': '\$100'},
    {'name': 'Transportation', 'amount': '\$50'},
    {'name': 'Entertainment', 'amount': '\$50'},
    {'name': 'Shopping', 'amount': '\$50'},
  ];

  void deleteCategory(int index) {
    setState(() {
      categories.removeAt(index);
      updateTotalExpense();
    });
  }

  void addCategory(String name, String amount) {
    setState(() {
      categories.add({'name': name, 'amount': amount});
      updateTotalExpense();
    });
  }

  void updateTotalExpense() {
    int totalExpense = categories.fold(0, (sum, category) {
      int parsedAmount = int.tryParse(category['amount']?.replaceAll('\$', '') ?? '0') ?? 0;
      return sum + parsedAmount;
    });
    setState(() {
      categoriesTotalExpense = totalExpense;
    });
  }


  int categoriesTotalExpense = 0;
  void initState() {
    super.initState();
    // Calculate and set the initial total expense based on sample data
    updateTotalExpense();
  }
  void _showAddCategoryDialog(BuildContext context) {
    String categoryName = '';
    String amount = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Expense Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Category Name'),
                onChanged: (value) {
                  categoryName = value;
                },
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(labelText: 'Expense Amount'),
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
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (categoryName.isNotEmpty && amount.isNotEmpty) {
                  addCategory(categoryName, amount);
                  Navigator.pop(context);
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Screen'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/home');
          },
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Expense Total Box
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.blue,
            ),
            child: Text(
              'Expense Total: \$${categoriesTotalExpense.toString()}', // Display the total expense
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 20),
          // Categories List
          for (int i = 0; i < categories.length; i++)
            CategoryRow(
              categoryName: categories[i]['name']!,
              amount: categories[i]['amount']!,
              onDelete: () {
                deleteCategory(i);
              },
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddCategoryDialog(context);
        },
        child: Icon(Icons.add),
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
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              categoryName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              amount,
              style: TextStyle(
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












