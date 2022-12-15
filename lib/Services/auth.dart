import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Models/user_m.dart';
import 'auth_exception_handler.dart';
import 'database.dart';

class Auth with ChangeNotifier {
  User? firebaseUser;
  bool isUserLoggedIn = false;
  int userRole = 0;
  UserM? _currentUserProfile;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  dynamic _status;

  Auth() {
    setPropertiesForNullUser();
  }

  Future<void> init() async {
    // Fetching current user authentication
    User? user = _auth.currentUser;
    await updateUser(user, shouldNotify: false);
  }

  Future<void> updateUser(User? user, {bool shouldNotify = true}) async {
    if (user == null) {
      setPropertiesForNullUser();
    } else {
      UserM? profile = await fetchProfileForFirebaseUser(user.uid);
      if (profile == null) {
        setPropertiesForNullUser();
      } else {
        setPropertiesForLoggedInUser(user, profile);
      }
    }
    if (shouldNotify) notifyListeners();
  }

  Future<AuthStatus> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _status = AuthStatus.successful;
    } on FirebaseAuthException catch (e) {
      _status = AuthExceptionHandler.handleAuthException(e);
    }
    return _status;
  }

  Future<AuthStatus> createAccount({
    required UserM user,
    required String password,
  }) async {
    try {
      //Create User into Firebase Auth
      await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );
      User newUser = _auth.currentUser!;
      user.uid = newUser.uid;

      //Create a Document for the user into User Collection
      await DatabaseService(uid: user.uid).updateUserData(user);

      _status = AuthStatus.successful;
    } on FirebaseAuthException catch (e) {
      _status = AuthExceptionHandler.handleAuthException(e);
    }
    return _status;
  }

  Future<AuthStatus> updateAccount({
    required UserM user,
    required String password,
    required String newPassword,
  }) async {
    try {
      user.uid = _auth.currentUser!.uid;

      //Changes inside Firebase Auth
      if (password.compareTo(newPassword) != 0) {
        //Reauthentication of the user
        reAuthenticate(oldPwd: password);
        changePassword(newPwd: newPassword);
      }
      if (user.email.compareTo(_auth.currentUser!.email) != 0) {
        reAuthenticate(oldPwd: password);
        changeEmail(newEmail: user.email);
      }

      //Update Document of the user inside Firestore
      await DatabaseService(uid: user.uid).updateUserData(user);

      _status = AuthStatus.successful;
    } on FirebaseAuthException catch (e) {
      _status = AuthExceptionHandler.handleAuthException(e);
    }
    return _status;
  }

  //Logout
  signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      await updateUser(_auth.currentUser, shouldNotify: true);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  //Updating the Email inside Firebase Auth
  Future<AuthStatus> changeEmail({required String newEmail}) async {
    try {
      await _auth.currentUser!.updateEmail(newEmail);
      log('Email changed to : $newEmail');
      _status = AuthStatus.successful;
    } on FirebaseAuthException catch (e) {
      _status = AuthExceptionHandler.handleAuthException(e);
    }
    return _status;
  }

  //Updating the Pwd inside Firebase Aut
  Future<AuthStatus> changePassword({required String newPwd}) async {
    try {
      await _auth.currentUser!.updatePassword(newPwd);
      log('Password reset');
      _status = AuthStatus.successful;
    } on FirebaseAuthException catch (e) {
      _status = AuthExceptionHandler.handleAuthException(e);
    }
    return _status;
  }

  Future<AuthStatus> forgotPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      log('email sent');
      _status = AuthStatus.successful;
    } on FirebaseAuthException catch (e) {
      _status = AuthExceptionHandler.handleAuthException(e);
    }
    return _status;
  }

//Reauthentication of the user
  Future<AuthStatus> reAuthenticate({required String oldPwd}) async {
    try {
      User user = _auth.currentUser!;
      final String email = user.email!;
      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: oldPwd);
      await user.reauthenticateWithCredential(credential);
      _status = AuthStatus.successful;
    } on FirebaseAuthException catch (e) {
      _status = AuthExceptionHandler.handleAuthException(e);
    }
    return _status;
  }

  setPropertiesForNullUser() {
    firebaseUser = null;
    isUserLoggedIn = false;
    userRole = 0;
    _currentUserProfile = null;
  }

  setPropertiesForLoggedInUser(User user, UserM profile) {
    firebaseUser = user;
    isUserLoggedIn = true;
    userRole = profile.role;
    _currentUserProfile = profile;
  }

  Future<UserM?> fetchProfileForFirebaseUser(String fbuid) async {
    UserM? profile = await fetchMyUserProfile(fbuid);
    return profile;
  }

  // External callers to access profile of user logged
  UserM? getUser() {
    return _currentUserProfile;
  }

  Future<UserM?> fetchMyUserProfile(String fbuid) async {
    DocumentSnapshot<Map<String, dynamic>> value =
        await FirebaseFirestore.instance.collection('Users').doc(fbuid).get();
    if (value.exists) {
      UserM? myUser = UserM.fromJson(value.data()!, fbuid);
      log('User Fetched : $myUser');
      return myUser;
    }
    return null;
  }
}
