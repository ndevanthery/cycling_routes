import 'package:cycling_routes/Screens/authenticate/register.dart';
import 'package:cycling_routes/Screens/authenticate/sign_in.dart';
import 'package:cycling_routes/Screens/wrapper.dart';
import 'package:flutter/material.dart';

import 'Shared/constants.dart';

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
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                  width: 300.0,
                  height: 300.0,
                  child: Image.asset(
                    'assets/img/not_found.png',
                    height: MediaQuery.of(_).size.height,
                    width: MediaQuery.of(_).size.width,
                    fit: BoxFit.cover,
                  )),
              const SizedBox(
                height: 30.0,
              ),
              const Text(
                'You seem to be lost...',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(239, 83, 80, 1)),
              ),
              const SizedBox(
                height: 30.0,
              ),
              ElevatedButton(
                  style: btnDecoration,
                  child: const Text(
                    "Go Back Home",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.of(_).pushNamed('/');
                  }),
            ],
          ),
        ),
      );
    });
  }
}
