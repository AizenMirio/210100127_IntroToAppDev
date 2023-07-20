import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Dummy user information
  Map<String, String> userInfo = {
    'User Name': 'Anonymous',
    'Email': 'dummy@example.com',
    'Age': '25',
    'Location': 'Anonymous City',
    'Salary' : '\$5000',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        title: const Center(
          child: Text(
            'Budget Tracker',
            style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        entry.value,
                        style: TextStyle(
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
          Navigator.pushNamed(context, '/expense'); // Navigate to the Expense Screen
        },
        icon: Icon(Icons.read_more),
        label: Text('Check Expense'),
      ),
    );
  }
}


