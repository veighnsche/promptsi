import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthApi {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static bool get isSignedIn {
    return FirebaseAuth.instance.currentUser != null;
  }

  static User get currentUser {
    return _auth.currentUser!;
  }

  static String get uid {
    return currentUser.uid;
  }

  static StreamSubscription isSingedInStream(
    Function(bool isSignedIn) callback,
  ) {
    return _auth.authStateChanges().listen((User? user) {
      callback(user != null);
    });
  }

  static Future<UserCredential> signUp(String email, String password) {
    try {
      return _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (_) {
      rethrow;
    }
  }

  static Future<UserCredential> email(String email, String password) {
    try {
      return _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (_) {
      rethrow;
    }
  }

  static Future<UserCredential> google() async {
    return GoogleSignIn().signIn().then<GoogleSignInAuthentication?>(
      (GoogleSignInAccount? googleUser) {
        if (googleUser != null) {
          return googleUser.authentication;
        }
        throw 'No Google sign in account';
      },
    ).then((GoogleSignInAuthentication? googleAuth) {
      if (googleAuth != null) {
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        return _auth.signInWithCredential(credential);
      }
      throw 'No Google sign in authentication';
    });
  }
}
