import 'package:cycling_routes/Screens/admin/admin_home.dart';
import 'package:cycling_routes/Screens/authenticate/authenticate.dart';
import 'package:cycling_routes/Screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/user_m.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserM?>(context);

    //If logged return Home Otherwise return Authenticate
    if (user == null) {
      return const Authenticate();
    } else {
      user.role =
          0; // simulate admin section while the provider isn't working correctly
      if (user.role == 1) {
        return AdminHome();
      }

      return Home();
    }
  }
}
