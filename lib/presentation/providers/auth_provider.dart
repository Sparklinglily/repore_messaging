import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:promptio/data/user_model.dart';
import 'package:promptio/presentation/auth/login_page.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  UserModel? user;
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;
  Future<void> fetchUserData() async {
    User? firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return;

    final doc =
        await _firestore.collection('users').doc(firebaseUser.uid).get();
    if (doc.exists) {
      _currentUser = UserModel.fromMap(doc.data()!);
      notifyListeners();
    }
  }

  Future<void> createUser(UserModel user) async {
    await _firestore.collection('users').doc(user.id).set(user.toMap());
  }

  Future<User?> createUserWithEmailAndPassword(
      String email, String password, String name,
      {UserRole role = UserRole.customer}) async {
    try {
      final credentials = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String uid = credentials.user!.uid;
      UserModel newUser =
          UserModel(id: uid, name: name, email: email, role: role);
      await createUser(newUser);
      _currentUser = newUser;
      notifyListeners();

      return credentials.user;
    } catch (e) {
      return null;
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      await fetchUserData();

      notifyListeners();
      return credential.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    _currentUser = null;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
    notifyListeners();
  }
}
