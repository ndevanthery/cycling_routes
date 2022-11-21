import 'package:cycling_routes/Screens/authenticate/authenticate.dart';
import 'package:cycling_routes/Screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/user_m.dart';
import 'authenticate/Welcome.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    final user = Provider.of<UserM?>(context);

    //If logged return Home Otherwise return Authenticate
    if (user == null) {
      return Welcome();
      //return const Authenticate();
    } else {
      return Home();
    }
  }
}
