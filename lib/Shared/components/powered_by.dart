import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PoweredBy extends StatelessWidget {
  const PoweredBy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3.0),
      color: Colors.transparent,
      width: double.infinity,
      height: 40.0,
      child: Center(
          child: Text(
        AppLocalizations.of(context)!.poweredByHesso,
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),
      )),
    );
  }
}
