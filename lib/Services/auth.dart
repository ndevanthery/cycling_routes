import 'package:cycling_routes/Models/user_m.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Create user Obj from FirebaseUser
  UserM? _userFromFirebase(User? user) {
    return user != null ? UserM(uid: user.uid) : null;
  }

  //auth Changes Stream
  Stream<UserM?> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  //Sign In
  Future signIn(email, password) async {
    try {
      UserCredential res = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      return _userFromFirebase(res.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //Register
  Future registerWithEmail(String email, String pwd) async {
    try {
      UserCredential res = await _auth.createUserWithEmailAndPassword(
          email: email, password: pwd);
      return _userFromFirebase(res.user);

    } catch (e) {
      print(e.toString());
      return null;      
    }
  }

  //Logout
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
