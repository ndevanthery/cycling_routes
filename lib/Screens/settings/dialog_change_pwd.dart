import 'dart:developer';

import 'package:cycling_routes/Shared/components/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../Models/user_m.dart';
import '../../Services/auth.dart';
import '../../Services/auth_exception_handler.dart';
import '../../Shared/constants.dart';

class DialogChangePwd extends StatefulWidget {
  const DialogChangePwd({
    Key? key,
  }) : super(key: key);

  @override
  State<DialogChangePwd> createState() => _DialogChangePwdState();
}

class _DialogChangePwdState extends State<DialogChangePwd> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController _oldPwdController = TextEditingController();
  final TextEditingController _newPwdController = TextEditingController();
  late bool isLoading;

  //Fields State
  late String pwd;
  late String newPwd;
  late String msg;
  late bool isError;
  late bool _oldpwdVisible;
  late bool _newpwdVisible;

  late Auth loginManager;
  @override
  initState() {
    msg = '';
    pwd = '';
    newPwd = '';
    isError = true;
    isLoading = false;
    _oldpwdVisible = false;
    _newpwdVisible = false;

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
    _newpwdVisible = false;
    _oldpwdVisible = false;
    _oldPwdController.dispose();
    _newPwdController.dispose();
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
            title: Text(AppLocalizations.of(context)!.editPassword),
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
                          height: 10.0,
                        ),
                        TextFormField(
                          controller: _newPwdController,
                          style: const TextStyle(color: Colors.black),
                          decoration: textInputDecoration.copyWith(
                            hintText: AppLocalizations.of(context)!.newPassword,
                            prefixIcon: const Icon(
                              Icons.lock_outline_rounded,
                              color: Colors.black,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                _newpwdVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                // Update the state i.e. toogle the state of passwordVisible variable
                                setState(() {
                                  _newpwdVisible = !_newpwdVisible;
                                });
                              },
                            ),
                          ),
                          validator: (value) => value!.length < 6
                              ? AppLocalizations.of(context)!.passwordValidation
                              : null,
                          obscureText: !_newpwdVisible,
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
                  textStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500), backgroundColor: Colors.grey[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: const EdgeInsets.all(13),
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
                  textStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600), backgroundColor: Colors.grey[500],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: const EdgeInsets.all(13),
                ),
                child: Text(AppLocalizations.of(context)!.save),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                    });
                    //Retrieve info entered by user
                    UserM myUser = loginManager.getUser()!;

                    final ExceptionStatus status;

                    //Call function to sign in the user into firebase Authentication
                    //AND Creating its document into firestore
                    status = await loginManager.updateCredentials(
                        user: myUser,
                        password: _oldPwdController.text,
                        newPassword: _newPwdController.text);

                    if (status == ExceptionStatus.successful) {
                      User newUser = FirebaseAuth.instance.currentUser!;
                      //Update the user logged in
                      await loginManager
                          .updateUserInApp(newUser, shouldNotify: true)
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
                          context.pop();
                        });
                      });
                    } else {
                      final newError =
                          ExceptionHandler.generateErrorMessage(context,status);
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
