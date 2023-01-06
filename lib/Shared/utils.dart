import 'package:cycling_routes/Shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../Screens/settings/dialog_change_email.dart';
import '../Screens/settings/dialog_change_pwd.dart';
import '../Services/auth_exception_handler.dart';
import '../Shared/components/terms_of_use.dart' as full_dialog_terms;
import '../Shared/components/app_about.dart' as full_dialog_app_about;

class Utils {
  static showLogoutConfirmDialog(BuildContext context, String title,
      String content, String okBtnString, String nokBtnString, loginManager) {
    String err = "";
    // set up the button
    Widget okButton = ElevatedButton(
        style: ElevatedButton.styleFrom(
          textStyle:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          backgroundColor: Colors.grey[500],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: const EdgeInsets.all(13),
        ),
        onPressed: (() async {
          ExceptionStatus status = await loginManager.signOut(context);

          if (status == ExceptionStatus.successful) {
            Navigator.of(context).pop();
            await loginManager
                .updateUserInApp(FirebaseAuth.instance.currentUser,
                    shouldNotify: true)
                .then((_) {
              //context.goNamed(baseRoute);
            });
          } else {
            err = 'An Error Occured, try again later';
          }
        }),
        child: Text(okBtnString));

    Widget nokButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        backgroundColor: Colors.grey[400],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: const EdgeInsets.all(13),
      ),
      child: Text(AppLocalizations.of(context)!.cancel3),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(content),
          Text(
            err,
            style: const TextStyle(color: Colors.red, fontSize: 14),
          )
        ],
      ),
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

  static Future<void> displaySmallDialog(
      BuildContext context, String currentCase) async {
    return showDialog(
        context: context,
        builder: (context) {
          switch (currentCase) {
            case openChangeEmailBoxSmall: //Edit Email
              return DialogChangeEmail(isDelete: false);

            case openChangePwdBoxSmall: //Edit Pwd
              return const DialogChangePwd();

            case openDeleteBoxSmall: //DELETE ACCOUNT
              return DialogChangeEmail(isDelete: true);

            default:
              return DialogChangeEmail(isDelete: false);
          }
        });
  }

  static Future openFullDialog(
      context, String currentCase, Function toggleTerms) async {
    dynamic result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          switch (currentCase) {
            case openTermsBoxFull:
              return const full_dialog_terms.TermOfUse();
            case openAboutBoxFull:
              return const full_dialog_app_about.AppAbout();
            default:
              return const full_dialog_app_about.AppAbout();
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
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
