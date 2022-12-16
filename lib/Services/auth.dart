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

  Future<ExceptionStatus> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _status = ExceptionStatus.successful;
    } on FirebaseAuthException catch (e) {
      _status = ExceptionHandler.handleAuthException(e);
    }
    return _status;
  }

  Future<ExceptionStatus> createAccount({
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

      _status = ExceptionStatus.successful;
    } on FirebaseAuthException catch (e) {
      _status = ExceptionHandler.handleAuthException(e);
    }
    return _status;
  }

  Future<ExceptionStatus> deleteAccount({
    required UserM user,
    required String password,
  }) async {
    try {
      User newUser = _auth.currentUser!;
      user.uid = newUser.uid;
//Reauthentication of the user
      _status = await reAuthenticate(oldPwd: password);

      //Can delete a Document into Users Collection only if pwd entered is right
      if (_status == ExceptionStatus.reauth) {
        _status = await DatabaseService(uid: user.uid).deleteUser(user);
      }

      if (_status == ExceptionStatus.dataDeleted) {
        //Delete User into Firebase Auth
        await _auth.currentUser!.delete();
        _status = ExceptionStatus.successful;
      }
    } on FirebaseAuthException catch (e) {
      _status = ExceptionHandler.handleAuthException(e);
    }
    return _status;
  }

  Future<ExceptionStatus> updateCredentials({
    required UserM user,
    required String password,
    required String? newPassword,
  }) async {
    try {
      user.uid = _auth.currentUser!.uid;
//Reauthentication of the user
      _status = await reAuthenticate(oldPwd: password);

      if (_status == ExceptionStatus.reauth) {
//Changes inside Firebase Auth
        if (newPassword == null) {
          if (user.email.compareTo(_auth.currentUser!.email) != 0) {
            changeEmail(newEmail: user.email);
            _status = ExceptionStatus.successful;
          } else {
            return ExceptionStatus.successful;
          }
        } else {
          if (password.compareTo(newPassword) != 0) {
            changePassword(newPwd: newPassword);
            _status = ExceptionStatus.successful;
          } else {
            return ExceptionStatus.successful;
          }
        }

        //Update Document of the user inside Firestore
        if (_status == ExceptionStatus.successful) {
          await DatabaseService(uid: user.uid).updateUserData(user);
        }

        _status = ExceptionStatus.successful;
      }
    } on FirebaseAuthException catch (e) {
      log('Whole Update Credential Method Error : $e');

      _status = ExceptionHandler.handleAuthException(e);
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
  Future<ExceptionStatus> changeEmail({required String newEmail}) async {
    try {
      await _auth.currentUser!.updateEmail(newEmail);
      log('Email changed to : $newEmail');
      _status = ExceptionStatus.successful;
    } on FirebaseAuthException catch (e) {
      log('Change Email Error : $e');

      _status = ExceptionHandler.handleAuthException(e);
    }
    return _status;
  }

  //Updating the Pwd inside Firebase Aut
  Future<ExceptionStatus> changePassword({required String newPwd}) async {
    try {
      await _auth.currentUser!.updatePassword(newPwd);
      log('Password reset');
      _status = ExceptionStatus.successful;
    } on FirebaseAuthException catch (e) {
      log('Change Pwd Error : $e');

      _status = ExceptionHandler.handleAuthException(e);
    }
    return _status;
  }

  Future<ExceptionStatus> forgotPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      log('email sent');
      _status = ExceptionStatus.successful;
    } on FirebaseAuthException catch (e) {
      _status = ExceptionHandler.handleAuthException(e);
    }
    return _status;
  }

//Reauthentication of the user
  Future<ExceptionStatus> reAuthenticate({required String oldPwd}) async {
    try {
      User user = _auth.currentUser!;
      final String email = user.email!;
      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: oldPwd);
      await user
          .reauthenticateWithCredential(credential)
          .then((value) => _status = ExceptionStatus.reauth);
    } on FirebaseAuthException catch (e) {
      log('Re-Auth Error : $e');
      _status = ExceptionHandler.handleAuthException(e);
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
