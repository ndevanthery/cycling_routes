import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../Services/auth.dart';
import '../../Shared/utils.dart';

class SettingsPage extends StatefulWidget {
  static const keyDarkMode = 'key-dark-mode';

  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    Auth loginManager = Provider.of<Auth>(context, listen: false);

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                AppLocalizations.of(context)!.settings,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),
            Column(
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      AppLocalizations.of(context)!.account,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                const Divider(
                  height: 20,
                  thickness: 1,
                ),
                const SizedBox(
                  height: 5.0,
                ),
                buildAccountOption(context, loginManager, 'Modify email', null,
                    Icons.arrow_forward_ios_rounded),
                buildAccountOption(context, loginManager, 'Modify password',
                    null, Icons.arrow_forward_ios_rounded),
                buildAccountOption(
                    context, loginManager, 'Logout', null, Icons.logout),
                buildAccountOption(context, loginManager, 'Delete Account',
                    Colors.red[300], Icons.delete),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.settings_applications,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      AppLocalizations.of(context)!.applicationSettings,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                const Divider(
                  height: 20,
                  thickness: 1,
                ),
                const SizedBox(
                  height: 5.0,
                ),
                buildAccountOption(context, loginManager, 'About RideOn', null,
                    Icons.info_outline_rounded),
              ],
            ),
          ],
        )));
  }

  GestureDetector buildAccountOption(BuildContext context, loginManager,
      String title, colorChoosed, IconData iconChoosed) {
    Color colorF = colorChoosed ?? Colors.grey[600];

    return GestureDetector(
      onTap: () async {
        switch (title) {
          case 'Modify email':
            Utils.displaySmallDialog(context, 1);
            break;

          case 'Modify password':
            Utils.displaySmallDialog(context, 2);
            break;

          case 'Logout':
            Utils.showLogoutConfirmDialog(
                context,
                AppLocalizations.of(context)!.logout,
                AppLocalizations.of(context)!.confirmDisconnect,
                AppLocalizations.of(context)!.logout2,
                AppLocalizations.of(context)!.cancel3,
                loginManager);
            break;

          case 'Delete Account':
            Utils.displaySmallDialog(context, 3);
            break;

          case 'About RideOn':
            Utils.openFullDialog(context, 'about', () {});
            break;
          default:
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w500, color: colorF),
            ),
            Icon(
              iconChoosed,
              color: colorF,
            )
          ],
        ),
      ),
    );
  }
}
