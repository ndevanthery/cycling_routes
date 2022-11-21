import 'package:cycling_routes/Screens/authenticate/register.dart';
import 'package:cycling_routes/Screens/authenticate/sign_in.dart';
import 'package:flutter/material.dart';

class Welcome extends StatefulWidget {
  Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image(
              image: AssetImage("velo_tour.jpg"),
              height: double.maxFinite,
              fit: BoxFit.fitHeight),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 200,
                width: double.maxFinite,
                decoration: BoxDecoration(
                    color: Color.fromARGB(240, 234, 230, 229),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30))),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text("Let's explore the world !"),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignIn(),
                                    ));
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 12),
                                child: Column(children: [
                                  Icon(
                                    Icons.login,
                                    color: Colors.black,
                                  ),
                                  Text("Login",
                                      style: TextStyle(color: Colors.black)),
                                ]),
                              )),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Register(),
                                    ));
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(255, 71, 87, 87),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 12),
                                child: Column(children: [
                                  Icon(
                                    Icons.app_registration,
                                    color: Colors.white,
                                  ),
                                  Text("Register",
                                      style: TextStyle(color: Colors.white)),
                                ]),
                              )),
                        ])
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
