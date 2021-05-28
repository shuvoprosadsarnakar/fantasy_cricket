import 'package:firebase_auth/firebase_auth.dart';
import 'package:fantasy_cricket/routing/routes.dart' as routes;

class AuthRepo {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<UserCredential> createUser(
      String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<bool> isEmailVerified() async {
    await _auth.currentUser.reload();
    return _auth.currentUser.emailVerified;
  }

  static Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static User getCurrentUser() {
    return _auth.currentUser;
  }

  static void signOut() async {
    await _auth.signOut();
  }

  static String getInitialRoute()  {
    if (_auth.currentUser.emailVerified && _auth.currentUser != null) {
      return routes.home;
    } else if (!_auth.currentUser.emailVerified && _auth.currentUser != null) {
      return routes.verifyEmail;
    } else {
      return routes.signIn;
    }
  }

  static Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
