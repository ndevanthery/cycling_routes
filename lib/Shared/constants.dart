// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';

//______
//TODO Add for Traduction
// const String rideOnTitle = 'Ride';
// const String firstOnboardTxt = "Welcome to RideOn. Let's find your way !";
// const String secndOnboardTxt =
//     "We help people finding the best road for their rides. ";
// const String thirdOnboardTxt = "We notify you if there's trouble in the road.";
// const String btnOnboardTxt = "Continue";
// const String skipTxt = 'Skip information';
//______

//Constants Used accross app
//Routes names
const String baseRoute = '/';
const String onboardingRoute = '/onBoardingScreenRoute';
const String loginRoute = '/loginScreenRoute';
const String registerRoute = '/registerScreenRoute';

//Case string for Dialogs
const String openTermsBoxFull = "openTermsBox";
const String openAboutBoxFull = "openAboutBox";
const String openChangeEmailBoxSmall = "openChangeEmailBoxSmall";
const String openChangePwdBoxSmall = "openChangePwdBoxSmall";
const String openDeleteBoxSmall = "openDeleteBoxSmall";


final RegExp emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

bool isPasswordValid(String password) {
  if (password.length < 6) return false;
  if (!password.contains(RegExp(r"[a-z]"))) return false;
  if (!password.contains(RegExp(r"[A-Z]"))) return false;
  if (!password.contains(RegExp(r"[0-9]"))) return false;
  if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false;
  return true;
}

final textInputDecoration = InputDecoration(
  isDense: true,
  contentPadding: const EdgeInsets.all(0),
  labelStyle: const TextStyle(color: Colors.black, fontSize: 14),
  hintStyle:
      const TextStyle(color: Color.fromARGB(255, 116, 116, 116), fontSize: 14),
  fillColor: Colors.white,
  filled: true,
  errorStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(15.0),
    gapPadding: 0.0,
    borderSide: const BorderSide(color: Colors.red, width: 1.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(15.0),
    gapPadding: 0.0,
    borderSide: const BorderSide(color: Colors.amberAccent, width: 2.0),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(15.0),
    gapPadding: 0.0,
    borderSide: const BorderSide(color: Colors.red, width: 2.0),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(15.0),
    gapPadding: 0.0,
    borderSide: const BorderSide(color: Colors.white, width: 2.0),
  ),
  disabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(15.0),
    gapPadding: 0.0,
    borderSide: const BorderSide(color: Colors.grey, width: 2.0),
  ),
);

ButtonStyle btnDecoration = ElevatedButton.styleFrom(
    foregroundColor: Colors.black,
    backgroundColor: Colors.grey[500],
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
    maximumSize: const Size(120.0, 50.0),
    minimumSize: const Size(120.0, 50.0),
    padding: const EdgeInsets.fromLTRB(3, 8, 3, 8));
