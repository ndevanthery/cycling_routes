import 'dart:developer';

import 'package:cycling_routes/Screens/admin/admin_home.dart';
import 'package:cycling_routes/Screens/home/home.dart';
import 'package:cycling_routes/Screens/onboarding/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Services/auth.dart';
import 'authenticate/authenticate_page.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  int? firstLaunch;

  @override
  void initState() {
    super.initState();
    _getShared();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getShared();
  }

  _getShared() async {
    log("Shared pref called");
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      firstLaunch = pref.getInt('onBoard');
    });
    log('${pref.getInt('onBoard')} = On wrapper');
  }

  @override
  Widget build(BuildContext context) {
    Auth loginManager = Provider.of<Auth>(context, listen: true);
    if (firstLaunch == 0) {
      //Then its not the first installation of the app
      if (!loginManager.isUserLoggedIn) {
        return const AuthenticatePage();
      } else {
        if (loginManager.userRole == 1) {
          return const AdminHome();
        }
        return const Home();
      }
    } else {
      log('Show Onboarding');
      //Otherwise it shows the onboarding pages
      return Onboarding(
        setFirstLaunch: (value) {
          setState(() {
            firstLaunch = value;
          });
        },
      );
    }
  }
}
