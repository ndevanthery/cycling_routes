import 'package:cycling_routes/Screens/authenticate/register.dart';
import 'package:cycling_routes/Services/auth.dart';
import 'package:cycling_routes/Shared/components/loading.dart';
import 'package:cycling_routes/Shared/components/powered_by.dart';
import 'package:flutter/material.dart';

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
  @override
  initState() {
    super.initState();
    email = '';
    pwd = '';
    error = '';
  }

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
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
                    Navigator.pop(context);
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
              body: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(224, 224, 224, 1),
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    margin: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
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
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(color: Colors.black),
                                decoration: textInputDecoration.copyWith(
                                    alignLabelWithHint: true,
                                    hintText: 'Email',
                                    prefixIcon: const Icon(
                                      Icons.mail_outline,
                                      color: Colors.black,
                                    )),
                                validator: (value) =>
                                    value == '' ? 'Enter an Email' : null,
                                onChanged: ((value) {
                                  setState(() => email = value);
                                }),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.visiblePassword,
                                style: TextStyle(color: Colors.black),
                                decoration: textInputDecoration.copyWith(
                                    hintText: 'Password',
                                    prefixIcon: const Icon(
                                      Icons.lock_outline_rounded,
                                      color: Colors.black,
                                    )),
                                validator: (value) => value!.length < 6
                                    ? 'Enter a 6+ chars password'
                                    : null,
                                obscureText: true,
                                onChanged: ((value) {
                                  setState(() => pwd = value);
                                }),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              ElevatedButton(
                                  style: btnDecoration,
                                  child: const Text(
                                    "Let's go !",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() => isLoading = true);
                                      await _auth
                                          .signIn(context, email, pwd)
                                          .then((value) {
                                        if (value == null) {
                                          setState(() {
                                            error =
                                                'Could not sign in with those credentials';
                                            isLoading = false;
                                          });
                                        }
                                        if (value != null) {
                                          setState(() {
                                            error = '';
                                            isLoading = false;
                                          });
                                        }
                                      }).onError((error, stackTrace) {
                                        setState(() {
                                          error =
                                              'Could not sign in with those credentials';
                                          isLoading = false;
                                        });
                                      });
                                    }
                                  }),
                              const SizedBox(
                                height: 12.0,
                              ),
                              Text(
                                error,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 14.0),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const PoweredBy(),
                ],
              ),
            ),
          ]);
  }
}
