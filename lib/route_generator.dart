import 'package:cycling_routes/Screens/authenticate/register.dart';
import 'package:cycling_routes/Screens/authenticate/sign_in.dart';
import 'package:cycling_routes/Screens/wrapper.dart';
import 'package:flutter/material.dart';

import 'Screens/home/home.dart';

class RouteGenerator {


  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const Wrapper());
      case '/signIn':
        return MaterialPageRoute(builder: (_) => const SignIn());
      case '/register':
        return MaterialPageRoute(builder: (_) => const Register());
      case '/home':
        return MaterialPageRoute(builder: (_) =>  Home());

      default:
        return _errorRoute();

//Example if need to pass data into constructor
      // case '/signIn':
      //   if (args is String) {
      //     return MaterialPageRoute(builder: (_) => SignIn( data: args,));
      //   }
      //   return _errorRoute();

      /**In files:
       *  Navigator.of(context).pushNamed('/namePage', arguments: data),
       */
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('You seem to be lost'),
        ),
      );
    });
  }
}
