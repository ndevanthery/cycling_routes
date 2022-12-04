import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cycling_routes/Models/user_m.dart';
import 'package:cycling_routes/Services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  //Create user Obj from FirebaseUser
  UserM? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    } else {
      var myUser = UserM(uid: user.uid);

      FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          var myData = documentSnapshot.data()! as Map<String, dynamic>;
          myUser.address = myData["address"];
          myUser.email = myData["email"];
          myUser.birthday = myData["birthday"];
          myUser.npa = myData["npa"];
          myUser.localite = myData["localite"];
          myUser.firstname = myData["firstname"];
          myUser.lastname = myData["lastname"];
          myUser.role = myData["role"];
          print('User Connected : $myUser' );
        } else {
          print('Document does not exist on the database');
        }      

      });
      //while (myUser.firstname == null) {}
            return myUser;
}
  }

  //auth Changes Stream
  Stream<UserM?> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  //Sign In
  Future signIn(context, email, password) async {
    try {
      UserCredential res = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      UserM? myUser =  _userFromFirebase(res.user);

      Navigator.pop(context, true);
      return myUser;
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  //Register
  Future registerWithEmail(context, email, pwd, firstname, lastname, address,
      npa, local, birthday) async {
    try {
      UserCredential res = await _auth.createUserWithEmailAndPassword(
          email: email, password: pwd);

      UserM? myUser = _userFromFirebase(res.user);
      myUser!.email = email;
      myUser.firstname = firstname;
      myUser.lastname = lastname;
      myUser.address = address;
      myUser.npa = npa;
      myUser.localite = local;
      myUser.birthday = birthday;
      myUser.role = 0;
      await DatabaseService(uid: myUser.uid).updateUserData(myUser);
      Navigator.pop(context, true);
      return myUser;
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
