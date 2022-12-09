// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:cycling_routes/Screens/admin/admin_home.dart';
import 'package:cycling_routes/Screens/authenticate/register.dart';
import 'package:cycling_routes/Screens/authenticate/sign_in.dart';
import 'package:cycling_routes/Screens/home/home.dart';
import 'package:cycling_routes/Screens/wrapper.dart';
import 'package:sailor/sailor.dart';

const String myinitalRoute = '/';
const String myLoginScreenRoute = '/loginScreenRoute';
const String myRegisterScreenRoute = '/registerScreenRoute';
const String myHomeUserRoute = '/homeUserRoute';
const String myHomeAdminRoute = '/homeAdminRoute';

class RoutesGenerator {
  static final sailor = Sailor(
    options:
        const SailorOptions(handleNameNotFoundUI: true, isLoggingEnabled: true),
  );

  static void createRoutes() async {
    sailor.addRoutes([
      SailorRoute(
        name: myinitalRoute,
        builder: (context, args, params) {
          return Wrapper();
        },
      ),
      SailorRoute(
        name: myLoginScreenRoute,
        builder: (context, args, params) {
          return const SignIn();
        },
      ),
      SailorRoute(
        name: myRegisterScreenRoute,
        builder: (context, args, params) {
          return const Register();
        },
      ),
      SailorRoute(
        name: myHomeUserRoute,
        builder: (context, args, params) {
          return Home();
        },
      ),
      SailorRoute(
        name: myHomeAdminRoute,
        builder: (context, args, params) {
          return const AdminHome();
        },
      )
    ]);
  }
}
