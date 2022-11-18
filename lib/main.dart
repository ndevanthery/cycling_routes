import 'package:cycling_routes/Services/auth.dart';
import 'package:cycling_routes/Shared/components/loading.dart';
import 'package:cycling_routes/route_generator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Models/user_m.dart';
import 'Shared/firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final Future<FirebaseApp> _firebaseApp = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _firebaseApp,
      builder: ((context, snapshot) {
        //If has error show something went wrong
        if (snapshot.hasError) {
          print('Error ; firebase connexion');
          return MaterialApp(
            home: Scaffold(
              body: Container(
                color: Colors.amber[100],
                child: const Center(
                    child: Text(
                  'An error occured, please try again later',
                  style: TextStyle(
                      color: Color.fromARGB(255, 212, 166, 0),
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                )),
              ),
            ),
          );
        } else if (snapshot.hasData) {
          //if has data show normal
          return StreamProvider<UserM?>.value(
            value: AuthService().user,
            initialData: null,
            child: const MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: '/',
              onGenerateRoute: RouteGenerator.generateRoute,
            ),
          );
        } else {
          //else show loading
          return const MaterialApp(
            home: Scaffold(
              body: Loading(),
            ),
          );
        }
      }),
    );
  }
}
