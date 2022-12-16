// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';

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
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
    maximumSize: const Size(120.0, 50.0),
    minimumSize: const Size(120.0, 50.0),
    padding: const EdgeInsets.fromLTRB(3, 8, 3, 8),
    primary: Colors.grey[500],
    onPrimary: Colors.black);
