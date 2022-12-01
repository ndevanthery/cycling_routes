import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import './terms_of_use.dart' as fullDialog;

class TermOfUseText extends StatelessWidget {
  Function toggleTerms;
  bool isAccepted;
  TermOfUseText({Key? key, required this.toggleTerms, required this.isAccepted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      color: Colors.transparent,
      width: double.infinity,
      child: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          isAccepted
              ? const Icon(
                  Icons.task_alt,
                  size: 20.0,
                  color: Colors.black87,
                )
              : const Icon(
                  Icons.not_interested_rounded,
                  size: 20.0,
                  color: Colors.black87,
                ),
          const SizedBox(
            width: 2.0,
          ),
          RichText(
            text: TextSpan(
              text: isAccepted ? ' I accept the ' : "I don't accept the ",
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 13.0,
              ),
              children: [
                TextSpan(
                    text: 'terms of use',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                      fontSize: 13.0,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _openAgreeDialog(context);
                      }),
              ],
            ),
          ),
        ],
      )),
    );
  }

  Future _openAgreeDialog(context) async {
    dynamic result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return const fullDialog.TermOfUse();
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
}