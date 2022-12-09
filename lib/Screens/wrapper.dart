import 'dart:developer';

import 'package:cycling_routes/Screens/admin/admin_home.dart';
import 'package:cycling_routes/Screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Services/auth.dart';
import 'authenticate/authenticate.dart';

class Wrapper extends StatelessWidget {
  Wrapper({Key? key}) : super(key: key);

  // final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    Auth loginManager = Provider.of<Auth>(context, listen: true);

    if (!loginManager.isUserLoggedIn) {
      return const Authenticate();
    } else if (loginManager.userRole == 1) {
      return const AdminHome();
    } else {
      return Home();
    }
    // return StreamBuilder(
    //   initialData: null,
    //   stream: _authService.auth.authStateChanges(),
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    //       dynamic wiget = _authService.userFromFirestore(
    //           _authService.auth.currentUser!, context);
    //       if (wiget != null) {
    //         return wiget;
    //       } else {
    //         return const Authenticate();
    //       }
    //       // //Retrieve User's Document
    //       // dynamic user =
    //       //     _authService.userFromFirestore(_authService.auth.currentUser);
    //       // log('User into Wrapper :: $user');
    //       // if (user!.role == 1) {
    //       //   return const AdminHome();
    //       // } else {
    //       //   return Home();
    //       // }
    //     }
    //     return const Authenticate();
    //   },
    // );
  }
}
