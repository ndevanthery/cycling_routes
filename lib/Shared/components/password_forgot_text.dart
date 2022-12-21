import 'package:cycling_routes/Shared/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordForgotText extends StatelessWidget {
  const PasswordForgotText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3.0),
      color: Colors.transparent,
      width: double.infinity,
      height: 40.0,
      child: Center(
        child: RichText(
          text: TextSpan(
            text: AppLocalizations.of(context)!.passwordForgot,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
              fontSize: 13.0,
            ),
            children: [
              TextSpan(
                  text: AppLocalizations.of(context)!.clickHere,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.0,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Utils.openFullDialog(context, 'pwd', () {});
                    }),
            ],
          ),
        ),
      ),
    );
  }
}
