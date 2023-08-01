import 'package:flutter/material.dart';
import '../models/user.dart';
import 'Authenticate/authenticate.dart';
import 'Logged_in/home.dart';
import 'package:provider/provider.dart';
// import 'lib/screens/Logged_in/home.dart';


class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User?>(context);
    print(user);

    // return either the Home or Authenticate widget
    if (user == null){
      return const Authenticate();
    } else {
      return Home();
    }

  }
}
