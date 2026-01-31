import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthServices {
  Future<bool> loginWithEmailAndPassword(String email, String passWord);

  Future<bool> registerWithEmailAndPassword(String email, String passWord);
  Future<bool> authenticateWithGoogle();

  User? currentUser();

  Future<void> logOut();
}

class AuthServicesImpl implements AuthServices {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<bool> loginWithEmailAndPassword(String email, String passWord) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: passWord,
    );
    final user = userCredential.user;
    if (user != null) {
      return true;
    } else {
      return false;
    }
    // throw UnimplementedError();
  }

  @override
  Future<bool> registerWithEmailAndPassword(
    String email,
    String passWord,
  ) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: passWord,
    );
    final user = userCredential.user;
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  User? currentUser() {
    return _firebaseAuth.currentUser;
  }

  @override
  Future<void> logOut() async {
    await GoogleSignIn.instance.signOut();
    await _firebaseAuth.signOut();
  }

  @override
  Future<bool> authenticateWithGoogle() async {
    try {
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      final userCredential = await _firebaseAuth.signInWithProvider(
        googleProvider,
      );

      final user = userCredential.user;
      if (user != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('Error during Google sign-in: $e');
      return false;
    }
  }
}
