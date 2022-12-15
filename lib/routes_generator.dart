// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:cycling_routes/Screens/admin/admin_home.dart';
import 'package:cycling_routes/Screens/authenticate/register.dart';
import 'package:cycling_routes/Screens/authenticate/sign_in.dart';
import 'package:cycling_routes/Screens/home/home.dart';
import 'package:cycling_routes/Screens/wrapper.dart';
import 'package:flutter/widgets.dart';
import 'package:sailor/sailor.dart';

const String myinitalRoute = '/';
const String myLoginScreenRoute = '/loginScreenRoute';
const String myRegisterScreenRoute = '/registerScreenRoute';
const String myHomeUserRoute = '/homeUserRoute';
const String myHomeAdminRoute = '/homeAdminRoute';
const dynamic transition = [
  SailorTransition.slide_from_bottom,
];

class RoutesGenerator {
  static  Sailor sailor = Sailor(
    options: SailorOptions(
      handleNameNotFoundUI: true,
      isLoggingEnabled: true,
      customTransition: MyCustomTransition(),
      defaultTransitions: [
        SailorTransition.slide_from_bottom,
        SailorTransition.zoom_in,
      ],
      defaultTransitionCurve: Curves.decelerate,
      defaultTransitionDuration: const Duration(milliseconds: 500),
    ),
  );

  static void createRoutes() async {
    sailor.addRoutes([
      SailorRoute(
          name: myinitalRoute,
          builder: (context, args, params) {
            return Wrapper();
          },
          customTransition: MyCustomTransition(),
          defaultTransitions: [SailorTransition.slide_from_left]),
      SailorRoute(
          name: myLoginScreenRoute,
          builder: (context, args, params) {
            return const SignIn();
          },
          defaultTransitions: [SailorTransition.slide_from_left]),
      SailorRoute(
          name: myRegisterScreenRoute,
          builder: (context, args, params) {
            return const Register();
          },
          defaultTransitions: [SailorTransition.slide_from_left]),
      SailorRoute(
          name: myHomeUserRoute,
          builder: (context, args, params) {
            return Home();
          },
          defaultTransitions: [SailorTransition.slide_from_left]),
      SailorRoute(
          name: myHomeAdminRoute,
          builder: (context, args, params) {
            return const AdminHome();
          },
          defaultTransitions: [SailorTransition.slide_from_left])
    ]);
  }
}

class MyCustomTransition extends CustomSailorTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
