import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Shared/components/terms_of_use.dart' as full_dialog_terms;
import '../Shared/components/password_forgot.dart' as full_dialog_pwd;
import '../Screens/settings/account_settings.dart' as full_dialog_account;

class Utils {
  static showConfirmDialog(BuildContext context, String title, String content,
      String okBtnString, String nokBtnString, loginManager) {
    // set up the button
    Widget okButton = TextButton(
        child: Text(okBtnString),
        onPressed: (() async {
          if (title.contains('Logout')) {
            await loginManager.signOut(context);
            log('Logout Confirmed');
          }
          if (title.contains('Delete')) {
            //await loginManager.deleteAccount(context);
            log('Delete Confirmed');
          }
          Navigator.of(context).pop();
        }));

    Widget nokButton = TextButton(
      child: Text(nokBtnString),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        nokButton,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static Future openDialog(
      context, String caseStr, Function toggleTerms) async {
    dynamic result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          if (caseStr.contains('terms')) {
            return const full_dialog_terms.TermOfUse();
          } else if (caseStr.contains('pwd')) {
            return const full_dialog_pwd.PasswordForgot();
          } else {
            return full_dialog_account.AccountSettings();
          }
        },
        fullscreenDialog: true));
    if (result != null) {
      if (result.contains('User Disagreed')) {
        toggleTerms(false);
      } else {
        toggleTerms(true);
      }
    } else {}
  }

  static showSnackBar(BuildContext context, String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}

class UserPreferences {
  static late SharedPreferences _preferences;

  static Map<dynamic, bool> myUserPrefs = {
    isDarkMode: false,
  };

  static var isDarkMode = false;

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();
}
