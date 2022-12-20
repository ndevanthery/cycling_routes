// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:cycling_routes/routes_generator.dart';
import 'package:flutter/material.dart';
import 'package:sailor/sailor.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Image.asset(
        "assets/img/bkg_authenticate.jpg",
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
      Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 230,
                  height: 80.0,
                  padding: const EdgeInsets.fromLTRB(2, 30, 0, 8),
                  child: Image.asset(
                    "assets/img/logo_removebg.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  height: 240.0,
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(224, 224, 224, 1),
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context)!.firstMessage,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                padding: const EdgeInsets.fromLTRB(3, 8, 3, 8),
                                minimumSize: const Size(97.0, 95.0),
                                maximumSize: const Size(97.0, 95.0),
                                primary: Colors.grey[500],
                                onPrimary: Colors.black),
                            onPressed: () {
                              RoutesGenerator.sailor.navigate(
                                myLoginScreenRoute,
                                transitions: [
                                  SailorTransition.slide_from_top,
                                ],
                                customTransition: MyCustomTransition(),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                  child: Image.asset(
                                    "assets/icons/login.png",
                                    height: 24.0,
                                    width: 24.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.login,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 30.0,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                padding: const EdgeInsets.fromLTRB(3, 8, 3, 8),
                                minimumSize: const Size(97.0, 95.0),
                                maximumSize: const Size(97.0, 95.0),
                                primary: Colors.grey[500],
                                onPrimary: Colors.black),
                            onPressed: () {
                              RoutesGenerator.sailor.navigate(
                                myRegisterScreenRoute,
                                transitions: [
                                  SailorTransition.slide_from_top,
                                ],
                                customTransition: MyCustomTransition(),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                  child: Image.asset(
                                    "assets/icons/signup_black.png",
                                    height: 25.0,
                                    width: 25.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Text(
                                  AppLocalizations.of(context)!.register,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    ]);
  }
}
