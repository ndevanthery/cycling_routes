// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';

final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

const textInputDecoration = InputDecoration(
  labelStyle: TextStyle(color: Colors.black),
  hintStyle: TextStyle(color: Colors.black),
  fillColor: Colors.white,
  filled: true,
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.amberAccent, width: 2.0),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
  ),
);

ButtonStyle btnDecoration = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
    maximumSize: const Size(120.0, 50.0),
    minimumSize: const Size(120.0, 50.0),
    padding: EdgeInsets.fromLTRB(3, 8, 3, 8),
    primary: Colors.grey[500],
    onPrimary: Colors.black);
