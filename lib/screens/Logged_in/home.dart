import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:assignment_week_2/services/auth.dart';
import 'package:assignment_week_2/screens/Logged_in/expense.dart';
import 'package:assignment_week_2/models/user.dart'; // Import the User class


class Home extends StatelessWidget {
  final AuthService _auth = AuthService(); // Create an instance of AuthService

  // Dummy user information
  Map<String, String> userInfo = {
    'User Name': 'Anonymous',
    'Email': 'dummy@example.com',
    'Age': '25',
    'Location': 'Anonymous City',
    'Salary': '\$5000',
  };

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context); // Get the current user information

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.yellow[700],
        title: const Text(
          'Budget Tracker',
          style: TextStyle(
            color: Colors.blueAccent,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          ElevatedButton.icon(
            icon: Icon(Icons.person),
            label: Text('Logout'),
            onPressed: () async {
              await _auth.signOut(); // Call the signOut method when the button is pressed
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/signIn', // Navigate to the sign-in page
                    (route) => false, // Remove all previous routes from the stack
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.teal[600],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircleAvatar(
                  radius: 60, // Adjust this value to change the icon size
                  backgroundColor: Colors.white, // You can change the background color here
                  child: Icon(
                    Icons.person,
                    size: 100, // Adjust this value to change the icon size
                    color: Colors.black, // You can change the icon color here
                  ),
                ),
              ),
            ),
            const Center(
              child: Text(
                'Welcome Back!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 45,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'User Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Display user information as key-value pairs
            Column(
              children: userInfo.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Text(
                        '${entry.key}:',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        entry.value,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (user != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExpenseScreen(user:user),
              ),
            );
          }
        },
        icon: const Icon(Icons.read_more),
        label: const Text('Check Expense'),
      ),

    );
  }
}


