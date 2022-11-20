import 'package:flutter/material.dart';

import '../../Services/auth.dart';
import '../../Shared/components/loading.dart';
import '../../Shared/components/powered_by.dart';
import '../../Shared/constants.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);
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

                                  await _auth
                                      .registerWithEmail(context, email, pwd)
                                      .then((value) {
                                    if (value == null) {
                                      print('Result is Null');
                                      setState(() {
                                        error =
                                            'Please check information entered and try again';
                                        isLoading = false;
                                      });
                                    }
                                    if (value != null) {
                                      print('Result :' + value);
                                      setState(() {
                                        error = '';
                                        isLoading = false;
                                      });
                                    }
                                  }).onError((error, stackTrace) {
                                    setState(() {
                                      print('Error' + error.toString());

                                      error =
                                          'Could not register for the moment try again later';
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
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  const PoweredBy(),
                ],
              ),
            ),
          ]);
  }
}
