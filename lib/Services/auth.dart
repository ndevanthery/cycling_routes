import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Models/user_m.dart';

class Auth with ChangeNotifier {
  User? firebaseUser;
  bool isUserLoggedIn = false;
  int userRole = 0;
  UserM? _currentUserProfile;

  Auth() {
    setPropertiesForNullUser();
  }

  Future<void> init() async {
    // Fetching current user authentication
    User? user = FirebaseAuth.instance.currentUser;
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

  //Logout
  signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      await updateUser(FirebaseAuth.instance.currentUser, shouldNotify: true);
    } catch (e) {
      log(e.toString());
      return null;
    }
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
