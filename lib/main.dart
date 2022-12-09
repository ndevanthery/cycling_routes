// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:cycling_routes/themes/custom_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sailor/sailor.dart';
import 'package:tuple/tuple.dart';

import 'Services/auth.dart';
import 'Shared/firebase_options.dart';
import 'routes_generator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Auth loginManager = Auth();
  await loginManager.init();
  RoutesGenerator.createRoutes();

  runApp(MyApp(
    loginManager: loginManager,
  ));
}

class MyApp extends StatefulWidget {
  final Auth loginManager;

  const MyApp({Key? key, required this.loginManager}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.loginManager,
      child: Selector<Auth, Tuple2<bool, int>>(
        selector: (_, loginManager) =>
            Tuple2(loginManager.isUserLoggedIn, loginManager.userRole),
        builder: (BuildContext context, loginManagerData, _) {
          return MaterialApp(
            theme: CustomTheme(),
            darkTheme: CustomNightTheme(),
            debugShowCheckedModeBanner: false,
            onGenerateRoute: RoutesGenerator.sailor.generator(),
            navigatorKey: RoutesGenerator.sailor.navigatorKey,
            navigatorObservers: [
              SailorLoggingObserver(),
              RoutesGenerator.sailor.navigationStackObserver,
            ],
            initialRoute: "/",
          );
        },
      ),
    );
  }
}
