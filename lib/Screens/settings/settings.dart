// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:cycling_routes/Screens/settings/dialog_change_email.dart';
import 'package:cycling_routes/Screens/settings/dialog_change_pwd.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:provider/provider.dart';

import '../../Services/auth.dart';
import '../../Services/database.dart';
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
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Settings',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),
            Column(
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: const [
                    Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Account',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Divider(
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
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: const [
                    Icon(
                      Icons.settings_applications,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Appplication settings',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Divider(
                  height: 20,
                  thickness: 1,
                ),
                const SizedBox(
                  height: 5.0,
                ),
              ],
            ),
          ],
        )));
  }

  GestureDetector buildAccountOption(BuildContext context, loginManager,
      String title, colorChoosed, iconChoosed) {
    dynamic colorF = colorChoosed == null ? Colors.grey[600] : colorChoosed;

    return GestureDetector(
      onTap: () async {
        switch (title) {
          case 'Modify email':
            _displayEditCredentialDialog(context, true);
            //Utils.openDialog(context, '', () {});
            break;
          case 'Modify password':
            _displayEditCredentialDialog(context, false);
            //Utils.openDialog(context, '', () {});
            break;
          case 'Logout':
            Utils.showConfirmDialog(
                context,
                'Logout',
                'Confirm to disconnect yourself.',
                'LOGOUT',
                'CANCEL',
                loginManager);

            break;

          case 'Delete Account':
            break;
          default:
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
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

  Future<void> _displayEditCredentialDialog(
      BuildContext context, isEmail) async {
    return showDialog(
        context: context,
        builder: (context) {
          return isEmail ? DialogChangeEmail() : DialogChangePwd();
        });
  }
}
