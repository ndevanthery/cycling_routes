// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:cycling_routes/routes_generator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../Services/auth.dart';
import '../../Services/auth_exception_handler.dart';
import '../constants.dart';

class PasswordForgot extends StatefulWidget {
  const PasswordForgot({Key? key}) : super(key: key);

  @override
  State<PasswordForgot> createState() => _PasswordForgotState();
}

class _PasswordForgotState extends State<PasswordForgot> {
  //Fields State
  late String email;
  late String msg;
  bool isErr = false;

  @override
  initState() {
    super.initState();
    email = '';
    msg = '';
    isErr = false;
  }

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    email = '';
    msg = '';
    isErr = false;
  }

  @override
  Widget build(BuildContext context) {
    Auth loginManager = Provider.of<Auth>(context, listen: true);

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[500],
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(5, 25, 10, 3),
                  padding: const EdgeInsets.fromLTRB(20, 10, 30, 0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      AppLocalizations.of(context)!.forgotPassword,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(5, 5, 10, 3),
                  padding: const EdgeInsets.fromLTRB(20, 10, 30, 0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      AppLocalizations.of(context)!.textForgotPassword,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 180,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(224, 224, 224, 1),
                          borderRadius: BorderRadius.all(Radius.circular(25))),
                      margin: const EdgeInsets.fromLTRB(15, 0, 10, 8),
                      padding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                              child: const Icon(
                                Icons.restart_alt_rounded,
                                color: Colors.black,
                                size: 45,
                              )),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                const SizedBox(
                                  height: 20.0,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  style: const TextStyle(color: Colors.black),
                                  decoration: textInputDecoration.copyWith(
                                      hintText: AppLocalizations.of(context)!
                                          .exampleEmail,
                                      prefixIcon: const Icon(
                                        Icons.mail_outline,
                                        color: Colors.black,
                                      )),
                                  validator: (value) {
                                    if (value == '') {
                                      return AppLocalizations.of(context)!
                                          .noEmail;
                                    } else if (!emailRegExp.hasMatch(value!)) {
                                      return AppLocalizations.of(context)!
                                          .notCorrectEmail;
                                    } else {
                                      return null;
                                    }
                                  },
                                  onChanged: ((value) {
                                    setState(() => email = value);
                                  }),
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  msg,
                                  style: TextStyle(
                                      color: isErr == true
                                          ? Colors.redAccent
                                          : Colors.green,
                                      fontSize: 14.0),
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                ElevatedButton(
                                    style: btnDecoration,
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .resetPassword,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() => isLoading = true);

                                        final status = await loginManager
                                            .forgotPassword(email: email);

                                        if (status == AuthStatus.successful) {
                                          setState(() {
                                            isLoading = false;
                                            isErr = false;
                                            msg = AppLocalizations.of(context)!
                                                .emailSent;
                                          });
                                          Future.delayed(
                                              const Duration(seconds: 5), () {
                                            log('Executed after 5 seconds');
                                            RoutesGenerator.sailor.pop();
                                          });
                                        } else {
                                          final myError = AuthExceptionHandler
                                              .generateErrorMessage(status);
                                          setState(() {
                                            isLoading = false;
                                            isErr = true;
                                            msg = myError;
                                          });
                                        }
                                      }
                                    }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ]),
        ),
      ),
    ));
  }
}
