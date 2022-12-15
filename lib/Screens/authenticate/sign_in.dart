import 'dart:developer';

import 'package:cycling_routes/Shared/components/loading.dart';
import 'package:cycling_routes/Shared/components/powered_by.dart';
import 'package:cycling_routes/routes_generator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Services/auth.dart';
import '../../Shared/constants.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  //Fields State
  late String email;
  late String pwd;
  late String error;
  bool _pwdVisible = false;
  @override
  initState() {
    super.initState();
    email = '';
    pwd = '';
    error = '';
    _pwdVisible = false;
  }

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Auth loginManager = Provider.of<Auth>(context, listen: true);

    return isLoading
        ? const Loading()
        : Stack(children: <Widget>[
            Image.asset(
              "assets/img/bkg_signin.jpg",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    RoutesGenerator.sailor.pop();
                  },
                  icon: Image.asset(
                    "assets/icons/back_white.png",
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                actions: [
                  SizedBox(
                    width: 140,
                    height: 70.0,
                    child: Image.asset(
                      "assets/img/logo_removebg.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              body: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: CustomScrollView(
                  scrollDirection: Axis.vertical,
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(5, 25, 10, 3),
                            padding: const EdgeInsets.fromLTRB(20, 10, 30, 0),
                            child: const Text(
                              'Welcome back on the App that boosts your rides !',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                    color: Color.fromRGBO(224, 224, 224, 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25))),
                                margin: const EdgeInsets.fromLTRB(15, 0, 10, 8),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 18, horizontal: 30),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 2),
                                      child: Image.asset(
                                        "assets/icons/login.png",
                                        height: 36.0,
                                        width: 36.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Form(
                                      key: _formKey,
                                      child: Column(
                                        children: <Widget>[
                                          const SizedBox(
                                            height: 20.0,
                                          ),
                                          TextFormField(
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            style: const TextStyle(
                                                color: Colors.black),
                                            decoration:
                                                textInputDecoration.copyWith(
                                                    hintText:
                                                        'example@gmail.com',
                                                    prefixIcon: const Icon(
                                                      Icons.mail_outline,
                                                      color: Colors.black,
                                                    )),
                                            validator: (value) {
                                              if (value == '') {
                                                return 'You must enter an Email';
                                              } else if (!emailRegExp
                                                  .hasMatch(value!)) {
                                                return 'You must enter a Valid Email ! ';
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
                                          TextFormField(
                                            keyboardType:
                                                TextInputType.visiblePassword,
                                            style: const TextStyle(
                                                color: Colors.black),
                                            decoration:
                                                textInputDecoration.copyWith(
                                              hintText: 'Password',
                                              prefixIcon: const Icon(
                                                Icons.lock_outline_rounded,
                                                color: Colors.black,
                                              ),
                                              suffixIcon: IconButton(
                                                icon: Icon(
                                                  // choose the icon Based on passwordVisible state
                                                  _pwdVisible
                                                      ? Icons.visibility
                                                      : Icons.visibility_off,
                                                  color: Colors.black,
                                                ),
                                                onPressed: () {
                                                  // Update the state of passwordVisible to the opposite
                                                  setState(() {
                                                    _pwdVisible = !_pwdVisible;
                                                  });
                                                },
                                              ),
                                            ),

                                            validator: (value) => value!
                                                        .length <
                                                    6
                                                ? 'You must enter : +6 characters'
                                                : null,
                                            //TODO : Update the validation of the Pwd  with this code below in Comments!!
                                            // // validator: (value) => !isPasswordValid(value!)
                                            // //     ? 'Must contain : +6 characters, Capital, small letter & Number & Special'
                                            // //     : null,
                                            obscureText: !_pwdVisible,
                                            onChanged: ((value) {
                                              setState(() => pwd = value);
                                            }),
                                          ),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            error,
                                            style: const TextStyle(
                                                color: Colors.red,
                                                fontSize: 14.0),
                                          ),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          ElevatedButton(
                                              style: btnDecoration,
                                              child: const Text(
                                                "Let's go !",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              onPressed: () async {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  setState(
                                                      () => isLoading = true);

                                                  //Sign In
                                                  try {
                                                    await FirebaseAuth.instance
                                                        .signInWithEmailAndPassword(
                                                            email: email,
                                                            password: pwd);

                                                    //Update User

                                                    await loginManager
                                                        .updateUser(
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser,
                                                            shouldNotify: true)
                                                        .then((value) {
                                                      setState(() =>
                                                          isLoading = false);
                                                      RoutesGenerator.sailor
                                                          .pop();
                                                    });
                                                  } on FirebaseAuthException catch (e) {
                                                    if (e.code ==
                                                        'user-not-found') {
                                                      log('No user found for that email.');
                                                      setState(() {
                                                        error =
                                                            'Account Not Found, please register yourself';
                                                        isLoading = false;
                                                      });
                                                    } else if (e.code ==
                                                        'wrong-password') {
                                                      log('Wrong password provided for that user.');
                                                      setState(() {
                                                        error =
                                                            'Wrong Password, please try again';
                                                        isLoading = false;
                                                      });
                                                    }
                                                  }

                                                  // await _auth
                                                  //     .signIn(
                                                  //         context, email, pwd)
                                                  //     .then((value) {
                                                  //   if (value != null) {
                                                  //     setState(() {
                                                  //       error = '';
                                                  //       isLoading = false;
                                                  //     });
                                                  //   }
                                                  //   if (value.toString() ==
                                                  //       'Account Not Found') {
                                                  //     setState(() {
                                                  //       error =
                                                  //           'Account Not Found, please register yourself';
                                                  //       isLoading = false;
                                                  //     });
                                                  //   }
                                                  //   if (value.toString() ==
                                                  //       'Account Disabled') {
                                                  //     setState(() {
                                                  //       error =
                                                  //           'Account Disabled, please register again';
                                                  //       isLoading = false;
                                                  //     });
                                                  //   }
                                                  //   if (value.toString() ==
                                                  //       'Wrong Password') {
                                                  //     setState(() {
                                                  //       error =
                                                  //           'Wrong Password, please try again';
                                                  //       isLoading = false;
                                                  //     });
                                                  //   }
                                                  //   if (value == null) {
                                                  //     setState(() {
                                                  //       error =
                                                  //           'Unkown error, please try again later';
                                                  //       isLoading = false;
                                                  //     });
                                                  //   }
                                                  // }).onError(
                                                  //         (error, stackTrace) {
                                                  //   setState(() {
                                                  //     error =
                                                  //         'Could not sign in for the moment try again later';
                                                  //     isLoading = false;
                                                  //   });
                                                  // });
                                                }
                                              }),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const PoweredBy(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]);
  }
}
