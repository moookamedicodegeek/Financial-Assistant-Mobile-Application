import 'package:firebase_auth/firebase_auth.dart';

class UserAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> signUp(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user; // Return the created user
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
      } else if (e.code == 'email-already-in-use') {
      } else {}
      return null;
    }
  }

  Future<User?> signIn(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
      } else if (e.code == 'wrong-password') {
      } else {}
      return null;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      try {
        await user.sendEmailVerification();
      } catch (e) {
        //
      }
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {}
  }

  User? get currentUser {
    return _firebaseAuth.currentUser;
  }

  Future<void> deleteUserAccount() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      try {
        await user.delete();
      } catch (e) {}
    }
  }

  Future<void> reAuthenticate(
      {required String email, required String password}) async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      try {
        AuthCredential credential =
            EmailAuthProvider.credential(email: email, password: password);
        await user.reauthenticateWithCredential(credential);
      } catch (e) {
        //Later
      }
    }
  }
}
