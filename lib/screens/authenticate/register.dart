import 'package:flutter/material.dart';
import '../../services/auth.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _email = '';
  String _password = '';
  String _errorMessage = '';

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        dynamic result = await _auth.registerWithEmailAndPassword(
          _email,
          _password,
        );

        if (result == null) {
          // Registration failed
          setState(() {
            _errorMessage = 'Error registering user. Please try again later.';
          });
        } else {
          // Registration successful
          print('User registered successfully');
          // Navigate to the home screen after successful registration
          Navigator.pushReplacementNamed(context, '/home');
        }
      } catch (e) {
        print('Error registering user: $e');
        setState(() {
          _errorMessage = 'Error registering user: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    _username = value!;
                  });
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    _email = value!;
                  });
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    _password = value!;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Register'),
              ),
              SizedBox(height: 10),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
