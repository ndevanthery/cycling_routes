import 'dart:developer';

import 'package:cycling_routes/Shared/components/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sailor/sailor.dart';

import '../../Models/user_m.dart';
import '../../Services/auth.dart';
import '../../Services/auth_exception_handler.dart';
import '../../Shared/constants.dart';
import '../../routes_generator.dart';

class DialogChangeEmail extends StatefulWidget {
  bool isDelete;
  DialogChangeEmail({Key? key, required this.isDelete}) : super(key: key);

  @override
  State<DialogChangeEmail> createState() => _DialogChangeEmailState();
}

class _DialogChangeEmailState extends State<DialogChangeEmail> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _oldPwdController = TextEditingController();
  late bool isLoading;

  //Fields State
  late String msg;
  late bool isError;
  late bool _oldpwdVisible;

  late Auth loginManager;
  @override
  initState() {
    msg = '';
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
    String email;
    if (loginManager.getUser() == null) {
      email = '';
    } else {
      email = loginManager.getUser()?.email;
    }

    if (widget.isDelete) _emailController.text = email;
    return isLoading
        ? const Loading()
        : AlertDialog(
            title: Text(widget.isDelete ? 'Delete my Account' : 'Edit Email'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'You must enter your current password to be able to make anything.',
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
                          enabled: !widget.isDelete,
                          controller: _emailController,
                          style: const TextStyle(color: Colors.black),
                          keyboardType: TextInputType.emailAddress,
                          decoration: textInputDecoration.copyWith(
                              fillColor: widget.isDelete
                                  ? Colors.grey[350]
                                  : Colors.white,
                              hintText: loginManager.getUser()!.email,
                              prefixIcon: const Icon(
                                Icons.mail_outline,
                                color: Colors.black,
                              )),
                          validator: (value) {
                            if (value == '') {
                              return 'You must enter an Email';
                            } else if (!emailRegExp.hasMatch(value!)) {
                              return 'You must enter a Valid Email ! ';
                            } else {
                              return null;
                            }
                          },
                        ),

                        const SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          controller: _oldPwdController,
                          style: const TextStyle(color: Colors.black),
                          decoration: textInputDecoration.copyWith(
                            hintText: 'Current Password',
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
                              ? 'You must enter : +6 characters'
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
              FlatButton(
                color: Colors.grey[400],
                textColor: Colors.white,
                child: const Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                color: widget.isDelete ? Colors.red[300] : Colors.grey[600],
                textColor: Colors.white,
                child: Text(widget.isDelete ? 'DELETE' : 'SAVE'),
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
                    if (widget.isDelete) {
                      status = await loginManager.deleteAccount(
                          user: myUser, password: _oldPwdController.text);
                    } else {
                      status = await loginManager.updateCredentials(
                          user: myUser,
                          password: _oldPwdController.text,
                          newPassword: null);
                    }

                    if (status == AuthStatus.successful) {
                      User? newUser = FirebaseAuth.instance.currentUser;
                      //Update the user logged in
                      await loginManager
                          .updateUser(newUser, shouldNotify: true)
                          .then((value) {
                        if (!widget.isDelete) {
                          setState(() {
                            isLoading = false;
                          });
                          setState(() {
                            isError = false;
                            msg =
                                'Changes Updated. You will be redirected to settings in 5 seconds.';
                          });
                          Future.delayed(const Duration(seconds: 5), () {
                            log('back to settings after 5 seconds');
                            RoutesGenerator.sailor.pop();
                          });
                        } else {
                          log('User Deleted');
                          RoutesGenerator.sailor.navigate(myinitalRoute,
                              navigationType: NavigationType.pushReplace);
                        }
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
