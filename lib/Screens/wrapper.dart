import 'package:cycling_routes/Screens/admin/admin_home.dart';
import 'package:cycling_routes/Screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Services/auth.dart';
import 'authenticate/authenticate_page.dart';

class Wrapper extends StatelessWidget {
  Wrapper({Key? key}) : super(key: key);

  // final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    Auth loginManager = Provider.of<Auth>(context, listen: true);

    if (!loginManager.isUserLoggedIn) {
      return const AuthenticatePage();
    } else {
      if (loginManager.userRole == 1) {
        return const AdminHome();
      }
      return const Home();
    }
  }
}
