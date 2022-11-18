import 'package:flutter/material.dart';

import '../../Services/auth.dart';
import '../../Shared/components/loading.dart';
import '../../Shared/constants.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  const Register({Key? key, required this.toggleView}) : super(key: key);
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
              title: const Text('Register'),
              actions: <Widget>[
                FlatButton.icon(
                  onPressed: () async {
                    widget.toggleView();
                  },
                  icon: const Icon(Icons.person),
                  label: const Text('Sign In'),
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
                      onChanged: (value) {
                        setState(() => email = value);
                      },
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
                          'Register',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => isLoading = true);

                            dynamic res =
                                await _auth.registerWithEmail(email, pwd);
                            if (res == null) {
                              setState(() {
                                error =
                                    'Please check information entered and try again';
                                isLoading = false;
                              });
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
