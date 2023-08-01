import 'package:assignment_week_2/screens/Logged_in/Expense.dart';
import 'package:assignment_week_2/screens/Logged_in/home.dart';
import 'package:assignment_week_2/screens/Wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/authenticate/signIn.dart';
import 'screens/authenticate/register.dart';
import 'models/user.dart';
import 'services/auth.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  final User? user;

  MyApp({super.key, this.user});
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      value: AuthService().user, // Stream of Firebase user
      initialData: null,
      child: MaterialApp(
        title: 'Budget Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => Wrapper(),
          '/signIn': (context) => SignIn(),
          '/register': (context) => RegisterScreen(),
          '/home': (context) => Home(),
          '/expense': (context) => ExpenseScreen(user: user)
        },
      ),
    );
  }
}