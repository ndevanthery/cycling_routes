// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  prefixIconColor: Colors.grey,
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
    padding:  EdgeInsets.fromLTRB(3, 8, 3, 8),
    primary: Colors.grey[500],
    onPrimary: Colors.black);
