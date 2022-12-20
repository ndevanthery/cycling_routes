import 'dart:developer';

import 'package:cycling_routes/Shared/components/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../Models/user_m.dart';
import '../../Services/auth.dart';
import '../../Services/auth_exception_handler.dart';
import '../../Shared/constants.dart';
import '../../routes_generator.dart';

class DialogChangeEmail extends StatefulWidget {
  const DialogChangeEmail({
    Key? key,
  }) : super(key: key);

  @override
  State<DialogChangeEmail> createState() => _DialogChangeEmailState();
}

class _DialogChangeEmailState extends State<DialogChangeEmail> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _oldPwdController = TextEditingController();
  late bool isLoading;

  //Fields State
  late String email;
  late String pwd;
  late String msg;
  late bool isError;
  late bool _oldpwdVisible;

  late Auth loginManager;
  @override
  initState() {
    msg = '';
    email = '';
    pwd = '';
    isError = true;
    isLoading = false;
    _oldpwdVisible = false;

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    msg = '';
    isError = true;
    isLoading = false;
    _oldpwdVisible = false;
    _emailController.dispose();
    _oldPwdController.dispose();
    super.dispose();
  }

  updateError(String err, bool iserror) {
    setState(() {
      msg = err;
      isError = iserror;
    });
    log('New Error Set : $msg');
  }

  @override
  Widget build(BuildContext context) {
    loginManager = Provider.of<Auth>(context, listen: true);

    return isLoading
        ? const Loading()
        : AlertDialog(
            title: Text(AppLocalizations.of(context)!.editEmail),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    AppLocalizations.of(context)!.enterCorrectPw,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(224, 224, 224, 1),
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                  margin: const EdgeInsets.fromLTRB(5, 0, 0, 5),
                  padding: const EdgeInsets.all(10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(
                          height: 18.0,
                        ),
                        TextFormField(
                          controller: _emailController,
                          style: const TextStyle(color: Colors.black),
                          keyboardType: TextInputType.emailAddress,
                          decoration: textInputDecoration.copyWith(
                              hintText: loginManager.getUser()!.email,
                              prefixIcon: const Icon(
                                Icons.mail_outline,
                                color: Colors.black,
                              )),
                          validator: (value) {
                            if (value == '') {
                              return AppLocalizations.of(context)!.noEmail;
                            } else if (!emailRegExp.hasMatch(value!)) {
                              return AppLocalizations.of(context)!
                                  .notCorrectEmail;
                            } else {
                              return null;
                            }
                          },
                        ),

                        const SizedBox(
                          height: 5.0,
                        ),
                        TextFormField(
                          controller: _oldPwdController,
                          style: const TextStyle(color: Colors.black),
                          decoration: textInputDecoration.copyWith(
                            hintText: AppLocalizations.of(context)!.currentPw,
                            prefixIcon: const Icon(
                              Icons.lock_outline_rounded,
                              color: Colors.black,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                _oldpwdVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                // Update the state i.e. toogle the state of passwordVisible variable
                                setState(() {
                                  _oldpwdVisible = !_oldpwdVisible;
                                });
                              },
                            ),
                          ),
                          validator: (value) => value!.length < 6
                              ? AppLocalizations.of(context)!.passwordValidation
                              : null,
                          obscureText: !_oldpwdVisible,
                        ),

                        const SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          msg,
                          style: TextStyle(
                              color: isError == true
                                  ? Colors.redAccent
                                  : Colors.green,
                              fontSize: 14.0),
                        ),
                        const SizedBox(
                          height: 3.0,
                        ),

                        //Update of User
                      ],
                    ),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[400],
                ),
                child: Text(AppLocalizations.of(context)!.cancel),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.grey[600],
                ),
                child: Text(AppLocalizations.of(context)!.save),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                    });
                    //Retrieve info entered by user
                    UserM myUser = loginManager.getUser()!;
                    myUser.email = _emailController.text.trim();

                    final AuthStatus status;

                    //Call function to sign in the user into firebase Authentication
                    //AND Creating its document into firestore
                    status = await loginManager.updateCredentials(
                        user: myUser,
                        password: _oldPwdController.text,
                        newPassword: null);

                    if (status == AuthStatus.successful) {
                      User newUser = FirebaseAuth.instance.currentUser!;
                      //Update the user logged in
                      await loginManager
                          .updateUser(newUser, shouldNotify: true)
                          .then((value) {
                        setState(() {
                          isLoading = false;
                        });
                        setState(() {
                          isError = false;
                          msg = AppLocalizations.of(context)!.changesUpdated;
                        });
                        Future.delayed(const Duration(seconds: 5), () {
                          log('back to settings after 5 seconds');
                          RoutesGenerator.sailor.pop();
                        });
                      });
                    } else {
                      final newError =
                          AuthExceptionHandler.generateErrorMessage(status);
                      updateError(newError, true);
                      setState(() {
                        isLoading = false;
                      });
                    }
                  }
                },
              ),
            ],
          );
  }
}
