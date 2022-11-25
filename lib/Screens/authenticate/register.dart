import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  TextEditingController dateInput = TextEditingController();

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  //Fields State
  late String email;
  late String pwd;
  late String error;
  late String firstname;
  late String lastname;
  late String address;
  late String npa;
  @override
  initState() {
    super.initState();
    email = '';
    pwd = '';
    error = '';
    firstname = '';
    lastname = '';
    address = '';
    npa = '';
    dateInput.text = "";
  }

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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(224, 224, 224, 1),
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 50),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            style: const TextStyle(color: Colors.black),
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Email',
                                prefixIcon: const Icon(
                                  Icons.mail_outline,
                                  color: Colors.black,
                                )),
                            validator: (value) =>
                                value == '' ? 'Enter an Email' : null,
                            onChanged: (value) {
                              setState(() => email = value);
                            },
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            style: const TextStyle(color: Colors.black),
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Firstname',
                                prefixIcon: const Icon(
                                  Icons.person_outline_rounded,
                                  color: Colors.black,
                                )),
                            validator: (value) =>
                                value == '' ? 'Enter your firstname' : null,
                            onChanged: (value) {
                              setState(() => firstname = value);
                            },
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            style: const TextStyle(color: Colors.black),
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Lastname',
                                prefixIcon: const Icon(
                                  Icons.person_outline_rounded,
                                  color: Colors.black,
                                )),
                            validator: (value) =>
                                value == '' ? 'Enter your Lastname' : null,
                            onChanged: (value) {
                              setState(() => lastname = value);
                            },
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            style: const TextStyle(color: Colors.black),
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Main Street, 13',
                                prefixIcon: const Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.black,
                                )),
                            validator: (value) =>
                                value == '' ? 'Enter your address' : null,
                            onChanged: (value) {
                              setState(() => address = value);
                            },
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            style: const TextStyle(color: Colors.black),
                            decoration: textInputDecoration.copyWith(
                                hintText: 'NPA, Locality',
                                prefixIcon: const Icon(
                                  Icons.mail_outline,
                                  color: Colors.black,
                                )),
                            validator: (value) => value == ''
                                ? 'Enter your NPA And locality'
                                : null,
                            onChanged: (value) {
                              setState(() => npa = value);
                            },
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            style: const TextStyle(color: Colors.black),
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
                            height: 10.0,
                          ),
                          TextFormField(
                            style: const TextStyle(color: Colors.black),
                            controller: dateInput,
                            validator: (value) =>
                                value!.length < 6 ? 'Select a Date' : null,
                            //editing controller of this TextField
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Select your Birthday',
                                prefixIcon: const Icon(
                                  Icons.calendar_today,
                                  color: Colors.black,
                                )),

                            readOnly: true,
                            //set it true, so that user will not able to edit text
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime(2100));

                              if (pickedDate != null) {
                                String formattedDate =
                                    DateFormat('dd-MM-yyyy').format(pickedDate);
                                setState(() {
                                  dateInput.text = formattedDate;
                                });
                              } else {}
                            },
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            error,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 14.0),
                          ),
                          ElevatedButton(
                              style: btnDecoration,
                              child: const Text(
                                'Register',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() => isLoading = true);

                                  await _auth
                                      .registerWithEmail(
                                          context,
                                          email,
                                          pwd,
                                          firstname,
                                          lastname,
                                          address,
                                          npa,
                                          dateInput.text)
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
                                      print('Error $error');

                                      error =
                                          'Could not register for the moment try again later';
                                      isLoading = false;
                                    });
                                  });
                                }
                              }),
                        ],
                      ),
                    ),
                  ),
                  const PoweredBy(),
                ],
              ),
            ),
          ]);
  }
}
