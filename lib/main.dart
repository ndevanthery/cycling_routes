import 'package:cycling_routes/Screens/authenticate/register.dart';
import 'package:cycling_routes/Screens/authenticate/sign_in.dart';
import 'package:cycling_routes/themes/custom_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:tuple/tuple.dart';
import 'Screens/wrapper.dart';
import 'Services/auth.dart';
import 'Shared/constants.dart';
import 'Shared/firebase_options.dart';
import 'l10n/l10n.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Auth loginManager = Auth();
  await loginManager.init();

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
          return GetMaterialApp.router(
            theme: CustomTheme(),
            darkTheme: CustomNightTheme(),
            debugShowCheckedModeBanner: false,
            routerDelegate: _router.routerDelegate,
            routeInformationParser: _router.routeInformationParser,
            routeInformationProvider: _router.routeInformationProvider,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: L10n.all,
            locale: Locale('en'),
          );
        },
      ),
    );
  }

  // GoRouter configuration
  final _router = GoRouter(
    initialLocation: myinitalRoute,
    routes: [
      GoRoute(
        name: myinitalRoute,
        path: myinitalRoute,
        builder: (context, state) => Wrapper(),
      ),
      GoRoute(
        name: myLoginScreenRoute,
        path: myLoginScreenRoute,
        pageBuilder: (context, state) {
          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: const SignIn(),
            transitionDuration: const Duration(milliseconds: 150),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        name: myRegisterScreenRoute,
        path: myRegisterScreenRoute,
        pageBuilder: (context, state) {
          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: const Register(),
            transitionDuration: const Duration(milliseconds: 150),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
                child: child,
              );
            },
          );
        },
      ),
    ],
  );
}
