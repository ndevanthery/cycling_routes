import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../Models/user_m.dart';
import '../../Services/auth.dart';
import '../../Services/auth_exception_handler.dart';
import '../../Services/database.dart';
import '../../routes_generator.dart';
import '../constants.dart';

class UserDataForm extends StatefulWidget {
  UserDataForm(
      {Key? key,
      required this.user,
      required this.error,
      required this.updateError,
      required this.isLoading,
      required this.updateLoading,
      required this.termsAccepted})
      : super(key: key);

  final UserM? user;

  final String error;
  final Function updateError;
  final bool isLoading;
  final Function updateLoading;
  final bool termsAccepted;

  @override
  State<UserDataForm> createState() => _UserDataFormState();
}

class _UserDataFormState extends State<UserDataForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _npaController = TextEditingController();
  final TextEditingController _localiteController = TextEditingController();

  late bool _pwdVisible;

  @override
  initState() {
    super.initState();
    _pwdVisible = false;
 }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.user != null) {
      _birthdayController.text = widget.user!.birthday;
      _emailController.text = widget.user!.email;
      _firstnameController.text = widget.user!.firstname;
      _lastnameController.text = widget.user!.lastname;
      _addressController.text = widget.user!.address;
      _npaController.text = widget.user!.npa;
      _localiteController.text = widget.user!.localite;
    } else {
      _birthdayController.text = "";
      _emailController.text = "";
      _firstnameController.text = "";
      _lastnameController.text = "";
      _addressController.text = "";
      _npaController.text = "";
      _localiteController.text = "";
    }
    _passwordController.text = "";
  }

  @override
  void dispose() {
    _birthdayController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    _addressController.dispose();
    _npaController.dispose();
    _localiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Auth loginManager = Provider.of<Auth>(context, listen: false);

    return Padding(
      padding: EdgeInsets.all(1),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              style: const TextStyle(color: Colors.black),
              keyboardType: TextInputType.emailAddress,
              decoration: textInputDecoration.copyWith(
                  hintText: 'example@gmail.com',
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
              height: 5.0,
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _firstnameController,
                    style: const TextStyle(color: Colors.black),
                    decoration: textInputDecoration.copyWith(
                        hintText: 'Firstname',
                        prefixIcon: const Icon(
                          Icons.person_outline_rounded,
                          color: Colors.black,
                        )),
                    validator: (value) =>
                        value == '' ? 'Enter your firstname' : null,
                  ),
                ),
                const SizedBox(
                  width: 5.0,
                ),
                Expanded(
                  child: TextFormField(
                    controller: _lastnameController,
                    style: const TextStyle(color: Colors.black),
                    decoration: textInputDecoration.copyWith(
                        hintText: 'Lastname',
                        prefixIcon: const Icon(
                          Icons.person_outline_rounded,
                          color: Colors.black,
                        )),
                    validator: (value) =>
                        value == '' ? 'Enter your Lastname' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5.0,
            ),
            TextFormField(
              controller: _addressController,
              style: const TextStyle(color: Colors.black),
              decoration: textInputDecoration.copyWith(
                  hintText: 'Main Street, 13',
                  prefixIcon: const Icon(
                    Icons.location_on_outlined,
                    color: Colors.black,
                  )),
              validator: (value) => value == '' ? 'Enter your address' : null,
            ),
            const SizedBox(
              height: 5.0,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    maxLength: 4,
                    controller: _npaController,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.black),
                    decoration: textInputDecoration.copyWith(
                        hintText: 'NPA',
                        counterStyle: const TextStyle(
                          height: double.minPositive,
                        ),
                        counterText: "",
                        prefixIcon: const Icon(
                          Icons.location_on_outlined,
                          color: Colors.black,
                        )),
                    validator: (value) =>
                        value!.length < 4 ? 'Enter your NPA' : null,
                  ),
                ),
                const SizedBox(
                  width: 5.0,
                ),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _localiteController,
                    style: const TextStyle(color: Colors.black),
                    decoration: textInputDecoration.copyWith(
                        hintText: 'Locality',
                        prefixIcon: const Icon(
                          Icons.location_on_outlined,
                          color: Colors.black,
                        )),
                    validator: (value) =>
                        value == '' ? 'Enter your locality' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5.0,
            ),
            TextFormField(
              style: const TextStyle(color: Colors.black),
              controller: _birthdayController,
              validator: (value) => value!.length < 6 ? 'Select a Date' : null,
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
                    _birthdayController.text = formattedDate;
                  });
                } else {}
              },
            ),
            const SizedBox(
              height: 5.0,
            ),
            TextFormField(
              controller: _passwordController,
              style: const TextStyle(color: Colors.black),
              decoration: textInputDecoration.copyWith(
                hintText: 'Password',
                prefixIcon: const Icon(
                  Icons.lock_outline_rounded,
                  color: Colors.black,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    _pwdVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable
                    setState(() {
                      _pwdVisible = !_pwdVisible;
                    });
                  },
                ),
              ),
              validator: (value) =>
                  value!.length < 6 ? 'You must enter : +6 characters' : null,
              obscureText: !_pwdVisible,
            ),
            const SizedBox(
              height: 5.0,
            ),

            Text(
              widget.error,
              style: const TextStyle(color: Colors.red, fontSize: 14.0),
            ),
            const SizedBox(
              height: 5.0,
            ),

            //Register User
            ElevatedButton(
                style: btnDecoration,
                child: const Text(
                  'Register',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  if (!widget.termsAccepted) {
                    widget.updateError(
                        'You have to accept the terms to continue');
                  } else {
                    widget.updateError('');

                    if (_formKey.currentState!.validate()) {
                      widget.updateLoading(true);

                      //Retrieve info entered by user
                      UserM? myUser = UserM(uid: '');
                      myUser.email = _emailController.text.trim();
                      myUser.firstname = _firstnameController.text;
                      myUser.lastname = _lastnameController.text;
                      myUser.address = _addressController.text;
                      myUser.npa = _npaController.text;
                      myUser.localite = _localiteController.text;
                      myUser.birthday = _birthdayController.text;
                      myUser.role = 0;
                      final AuthStatus status;

                      //Call function to sign in the user into firebase Authentication
                      //AND Creating its document into firestore
                      status = await loginManager.createAccount(
                        user: myUser,
                        password: _passwordController.text,
                      );

                      if (status == AuthStatus.successful) {
                        User newUser = FirebaseAuth.instance.currentUser!;
                        //Update the user logged in
                        await loginManager
                            .updateUser(newUser, shouldNotify: true)
                            .then((value) {
                          widget.updateLoading(false);

                          RoutesGenerator.sailor.pop();
                        });
                      } else {
                        final newError =
                            AuthExceptionHandler.generateErrorMessage(status);
                        widget.updateError(newError);
                        widget.updateLoading(false);
                      }
                    }
                  }
                })

            //Update of User
          ],
        ),
      ),
    );
  }
}
