import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:assignment_week_2/models/user.dart' as CustomUser;


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // If you plan to use Firestore

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create user obj based on firebase user
  CustomUser.User? _userFromFirebaseUser(firebase_auth.User? user) {
    return user != null ? CustomUser.User(uid: user.uid) : null;
  }



  // Auth change user stream
  Stream<CustomUser.User?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }



  // Sign in anonymously
  Future signInAnon() async {
    try {
      firebase_auth.UserCredential result = await _auth.signInAnonymously();
      firebase_auth.User? user = result.user;



      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      firebase_auth.UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      firebase_auth.User? user = result.user;

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      firebase_auth.UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      firebase_auth.User? user = result.user;

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}