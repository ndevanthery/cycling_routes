import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class OnboardingContent extends StatelessWidget {
  const OnboardingContent({
    Key? key,
    required this.txt,
    required this.img,
  }) : super(key: key);
  final String txt, img;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(flex: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                AppLocalizations.of(context)!.rideOnTitle,
                style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800]),
                // AppLocalizations.of(context)!.rideOn,
              ),
            ),
            Image.asset(
              'assets/img/on_logo.png',
              height: 128,
              width: 108,
            ),
          ],
        ),
        const Spacer(flex: 1),
        Padding(
          padding: const EdgeInsets.only(right: 40, left: 40, top: 22.0),
          child: Text(
            textAlign: TextAlign.center,
            txt,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        const Spacer(),
        Image.asset(
          img,
          height: 260,
          width: 280,
        )
      ],
    );
  }
}
