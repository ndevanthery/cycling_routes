import 'dart:developer';

import 'package:cycling_routes/Shared/components/terms_of_use_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../Models/user_m.dart';
import '../../Services/auth.dart';
import '../../Services/auth_exception_handler.dart';
import '../../Shared/components/loading.dart';
import '../../Shared/components/powered_by.dart';
import '../../Shared/constants.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late bool isLoading;
  late bool termAccepted;
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

  //Fields State
  late String error;

  @override
  initState() {
    super.initState();
    error = '';
    isLoading = false;
    termAccepted = true;
    _pwdVisible = false;
  }

  @override
  void dispose() {
    error = '';
    isLoading = false;
    termAccepted = true;
    super.dispose();
  }

  toggleTerms(bool isAccepted) {
    setState(() {
      termAccepted = isAccepted;
    });
    log('Update agreement to $termAccepted');
  }

  updateError(String err) {
    setState(() {
      error = err;
    });
    log('New Error Set : $error');
  }

  updateLoading(bool isLoad) {
    setState(() {
      isLoading = isLoad;
    });
    log('is loading : $isLoading');
  }

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
                    context.pop();
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(10, 25, 10, 3),
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Text(
                              AppLocalizations.of(context)!.registerTitle,
                              style: const TextStyle(
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
                                    vertical: 15, horizontal: 30),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(1),
                                      child: Form(
                                        key: _formKey,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            TextFormField(
                                              controller: _emailController,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              decoration:
                                                  textInputDecoration.copyWith(
                                                      hintText:
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .exampleEmail,
                                                      prefixIcon: const Icon(
                                                        Icons.mail_outline,
                                                        color: Colors.black,
                                                      )),
                                              validator: (value) {
                                                if (value == '') {
                                                  return AppLocalizations.of(
                                                          context)!
                                                      .noEmail;
                                                } else if (!emailRegExp
                                                    .hasMatch(value!)) {
                                                  return AppLocalizations.of(
                                                          context)!
                                                      .notCorrectEmail;
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
                                                    controller:
                                                        _firstnameController,
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                    decoration: textInputDecoration
                                                        .copyWith(
                                                            hintText:
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .firstname,
                                                            prefixIcon:
                                                                const Icon(
                                                              Icons
                                                                  .person_outline_rounded,
                                                              color:
                                                                  Colors.black,
                                                            )),
                                                    validator: (value) =>
                                                        value == ''
                                                            ? AppLocalizations
                                                                    .of(context)!
                                                                .enterFirstname
                                                            : null,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 5.0,
                                                ),
                                                Expanded(
                                                  child: TextFormField(
                                                    controller:
                                                        _lastnameController,
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                    decoration: textInputDecoration
                                                        .copyWith(
                                                            hintText:
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .lastname,
                                                            prefixIcon:
                                                                const Icon(
                                                              Icons
                                                                  .person_outline_rounded,
                                                              color:
                                                                  Colors.black,
                                                            )),
                                                    validator: (value) =>
                                                        value == ''
                                                            ? AppLocalizations
                                                                    .of(context)!
                                                                .enterLastname
                                                            : null,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5.0,
                                            ),
                                            TextFormField(
                                              controller: _addressController,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                              decoration:
                                                  textInputDecoration.copyWith(
                                                      hintText:
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .mainStreet13,
                                                      prefixIcon: const Icon(
                                                        Icons
                                                            .location_on_outlined,
                                                        color: Colors.black,
                                                      )),
                                              validator: (value) => value == ''
                                                  ? AppLocalizations.of(
                                                          context)!
                                                      .enterAddress
                                                  : null,
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
                                                    maxLengthEnforcement:
                                                        MaxLengthEnforcement
                                                            .enforced,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                    decoration: textInputDecoration
                                                        .copyWith(
                                                            hintText:
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .npa,
                                                            counterStyle:
                                                                const TextStyle(
                                                              height: double
                                                                  .minPositive,
                                                            ),
                                                            counterText: "",
                                                            prefixIcon:
                                                                const Icon(
                                                              Icons
                                                                  .location_on_outlined,
                                                              color:
                                                                  Colors.black,
                                                            )),
                                                    validator: (value) => value!
                                                                .length <
                                                            4
                                                        ? AppLocalizations.of(
                                                                context)!
                                                            .enterNpa
                                                        : null,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 5.0,
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: TextFormField(
                                                    controller:
                                                        _localiteController,
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                    decoration: textInputDecoration
                                                        .copyWith(
                                                            hintText:
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .locality,
                                                            prefixIcon:
                                                                const Icon(
                                                              Icons
                                                                  .location_on_outlined,
                                                              color:
                                                                  Colors.black,
                                                            )),
                                                    validator: (value) =>
                                                        value == ''
                                                            ? AppLocalizations
                                                                    .of(context)!
                                                                .enterLocality
                                                            : null,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5.0,
                                            ),
                                            TextFormField(
                                              style: const TextStyle(
                                                  color: Colors.black),
                                              controller: _birthdayController,
                                              validator: (value) =>
                                                  value!.length < 6
                                                      ? AppLocalizations.of(
                                                              context)!
                                                          .selectDate
                                                      : null,
                                              //editing controller of this TextField
                                              decoration:
                                                  textInputDecoration.copyWith(
                                                      hintText:
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .selectBirthday,
                                                      prefixIcon: const Icon(
                                                        Icons.calendar_today,
                                                        color: Colors.black,
                                                      )),

                                              readOnly: true,
                                              //set it true, so that user will not able to edit text
                                              onTap: () async {
                                                DateTime? pickedDate =
                                                    await showDatePicker(
                                                        context: context,
                                                        initialDate:
                                                            DateTime.now(),
                                                        firstDate:
                                                            DateTime(1950),
                                                        lastDate:
                                                            DateTime(2100));

                                                if (pickedDate != null) {
                                                  String formattedDate =
                                                      DateFormat('dd-MM-yyyy')
                                                          .format(pickedDate);
                                                  setState(() {
                                                    _birthdayController.text =
                                                        formattedDate;
                                                  });
                                                } else {}
                                              },
                                            ),
                                            const SizedBox(
                                              height: 5.0,
                                            ),
                                            TextFormField(
                                              controller: _passwordController,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                              decoration:
                                                  textInputDecoration.copyWith(
                                                hintText: AppLocalizations.of(
                                                        context)!
                                                    .password,
                                                prefixIcon: const Icon(
                                                  Icons.lock_outline_rounded,
                                                  color: Colors.black,
                                                ),
                                                suffixIcon: IconButton(
                                                  icon: Icon(
                                                    // Based on passwordVisible state choose the icon
                                                    _pwdVisible
                                                        ? Icons.visibility
                                                        : Icons.visibility_off,
                                                    color: Colors.black,
                                                  ),
                                                  onPressed: () {
                                                    // Update the state i.e. toogle the state of passwordVisible variable
                                                    setState(() {
                                                      _pwdVisible =
                                                          !_pwdVisible;
                                                    });
                                                  },
                                                ),
                                              ),
                                              validator: (value) =>
                                                  value!.length < 6
                                                      ? AppLocalizations.of(
                                                              context)!
                                                          .passwordValidation
                                                      : null,
                                              obscureText: !_pwdVisible,
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

                                            //Register User
                                            ElevatedButton(
                                                style: btnDecoration,
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .register,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                onPressed: () async {
                                                  if (!termAccepted) {
                                                    updateError(AppLocalizations
                                                            .of(context)!
                                                        .acceptTermstoContinue);
                                                  } else {
                                                    updateError('');

                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      updateLoading(true);

                                                      //Retrieve info entered by user
                                                      UserM? myUser = UserM(
                                                          uid: '',
                                                          fav: <String>[]);
                                                      myUser.email =
                                                          _emailController.text
                                                              .trim();
                                                      myUser.firstname =
                                                          _firstnameController
                                                              .text;
                                                      myUser.lastname =
                                                          _lastnameController
                                                              .text;
                                                      myUser.address =
                                                          _addressController
                                                              .text;
                                                      myUser.npa =
                                                          _npaController.text;
                                                      myUser.localite =
                                                          _localiteController
                                                              .text;
                                                      myUser.birthday =
                                                          _birthdayController
                                                              .text;
                                                      myUser.role = 0;
                                                      final ExceptionStatus
                                                          status;

                                                      //Call function to sign in the user into firebase Authentication
                                                      //AND Creating its document into firestore
                                                      status =
                                                          await loginManager
                                                              .createAccount(
                                                        user: myUser,
                                                        password:
                                                            _passwordController
                                                                .text,
                                                      );

                                                      if (status ==
                                                          ExceptionStatus
                                                              .successful) {
                                                        User newUser =
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser!;
                                                        //Update the user logged in
                                                        await loginManager
                                                            .updateUserInApp(
                                                                newUser,
                                                                shouldNotify:
                                                                    true)
                                                            .then((value) {
                                                          updateLoading(false);

                                                          context.goNamed(
                                                              baseRoute);
                                                        });
                                                      } else {
                                                        final newError =
                                                            ExceptionHandler
                                                                .generateErrorMessage(
                                                                    context,
                                                                    status);
                                                        updateError(newError);
                                                        updateLoading(false);
                                                      }
                                                    }
                                                  }
                                                })

                                            //Update of User
                                          ],
                                        ),
                                      ),
                                    ),
                                    // UserDataForm(
                                    //   user: loginManager.getUser(),
                                    //   error: error,
                                    //   updateError: updateError,
                                    //   isLoading: isLoading,
                                    //   updateLoading: updateLoading,
                                    //   termsAccepted: termAccepted,
                                    // ),
                                    TermOfUseText(
                                        toggleTerms: toggleTerms,
                                        isAccepted: termAccepted),
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
