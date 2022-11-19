import 'package:cycling_routes/Screens/authenticate/register.dart';
import 'package:cycling_routes/Services/auth.dart';
import 'package:cycling_routes/Shared/components/loading.dart';
import 'package:flutter/material.dart';

import '../../Shared/constants.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  //Fields State
  String email = '';
  String pwd = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              title: const Text('Sign In'),
              actions: <Widget>[
                FlatButton.icon(
                  onPressed: () async {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Register(),
                        ));
                  },
                  icon: const Icon(Icons.person),
                  label: const Text('Register'),
                )
              ],
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                        hintText: 'Email',
                      ),
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
                      decoration: textInputDecoration.copyWith(
                        hintText: 'Password',
                      ),
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
                    RaisedButton(
                        color: Colors.amberAccent,
                        child: const Text(
                          'Sign In',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => isLoading = true);

                            dynamic res = await _auth.signIn(email, pwd);
                            if (res == null) {
                              setState(() {
                                error =
                                    'Could not sign in with those credentials';
                                isLoading = false;
                              });
                            } else {
                              Navigator.pop(context);
                            }
                          }
                        }),
                    const SizedBox(
                      height: 12.0,
                    ),
                    Text(
                      error,
                      style: const TextStyle(color: Colors.red, fontSize: 14.0),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
