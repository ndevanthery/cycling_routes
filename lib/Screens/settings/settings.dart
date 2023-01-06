import 'package:cycling_routes/Shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:settings_ui/settings_ui.dart';

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
          child: SettingsList(
              darkTheme: SettingsThemeData(
                  settingsListBackground: Get.theme.scaffoldBackgroundColor),
              lightTheme: SettingsThemeData(
                  settingsListBackground: Get.theme.scaffoldBackgroundColor),
              physics: const BouncingScrollPhysics(),
              sections: [
                SettingsSection(
                    title: Row(
                      children: [
                        const Icon(Icons.person),
                        const SizedBox(
                          width: 16,
                        ),
                        Text(
                          AppLocalizations.of(context)!.account,
                          style: TextStyle(color: Get.iconColor, fontSize: 20),
                        )
                      ],
                    ),
                    tiles: [
                      SettingsTile.navigation(
                        trailing: const Icon(Icons.navigate_next),
                        title: Text(AppLocalizations.of(context)!.modifyEmail),
                        onPressed: (value) {
                          Utils.displaySmallDialog(context, openChangeEmailBoxSmall);
                        },
                      ),
                      SettingsTile.navigation(
                        trailing: const Icon(Icons.navigate_next),
                        title:
                            Text(AppLocalizations.of(context)!.modifyPassword),
                        onPressed: (value) {
                          Utils.displaySmallDialog(context, openChangePwdBoxSmall);
                        },
                      ),
                      SettingsTile.navigation(
                        trailing: const Icon(Icons.logout),
                        title: Text(AppLocalizations.of(context)!.logout),
                        onPressed: (value) {
                          Utils.showLogoutConfirmDialog(
                              context,
                              AppLocalizations.of(context)!.logout,
                              AppLocalizations.of(context)!.confirmDisconnect,
                              AppLocalizations.of(context)!.logout2,
                              AppLocalizations.of(context)!.cancel3,
                              loginManager);
                        },
                      ),
                      SettingsTile.navigation(
                        trailing: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        title: Text(
                          AppLocalizations.of(context)!.deleteAccount,
                          style: const TextStyle(color: Colors.red),
                        ),
                        onPressed: (value) {
                          Utils.displaySmallDialog(context, openDeleteBoxSmall);
                        },
                      ),
                    ]),
                SettingsSection(
                    title: Row(
                      children: [
                        const Icon(Icons.settings),
                        const SizedBox(
                          width: 16,
                        ),
                        Text(
                          AppLocalizations.of(context)!.applicationSettings,
                          style: TextStyle(color: Get.iconColor, fontSize: 20),
                        )
                      ],
                    ),
                    tiles: [
                      SettingsTile.navigation(
                        trailing: const Icon(
                          Icons.language,
                        ),
                        title: Text(
                          AppLocalizations.of(context)!.language,
                        ),
                        onPressed: (value) {
                          _showLanguageDialog(context);
                        },
                      ),
                      SettingsTile.navigation(
                        trailing: const Icon(
                          Icons.info,
                        ),
                        title: Text(
                          AppLocalizations.of(context)!.aboutRideOn,
                        ),
                        onPressed: (value) {
                          Utils.openFullDialog(context, 'about', () {});
                        },
                      ),
                    ]),
              ]),
        ));
  }

  Future<void> _showLanguageDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Change Language'),
          children: <Widget>[
            SimpleDialogOption(
              child: const Text('Bulgarian'),
              onPressed: () async {
                // set the app's language to Bulgarian using the Get package
                await Get.updateLocale(const Locale('bg'));
                // close the dialog
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: const Text('Czech'),
              onPressed: () async {
                // set the app's language to Czech using the Get package
                await Get.updateLocale(const Locale('cs'));
                // close the dialog
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: const Text('Danish'),
              onPressed: () async {
                // set the app's language to Danish using the Get package
                await Get.updateLocale(const Locale('da'));
                // close the dialog
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: const Text('Greek'),
              onPressed: () async {
                // set the app's language to Greek using the Get package
                await Get.updateLocale(const Locale('el'));
                // close the dialog
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: const Text('English'),
              onPressed: () async {
                // set the app's language to English using the Get package
                await Get.updateLocale(const Locale('en'));
                // close the dialog
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: const Text('Spanish'),
              onPressed: () async {
                // set the app's language to Spanish using the Get package
                await Get.updateLocale(const Locale('es'));
                // close the dialog
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: const Text('Estonian'),
              onPressed: () async {
                // set the app's language to Estonian using the Get package
                await Get.updateLocale(const Locale('et'));
                // close the dialog
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: const Text('Finnish'),
              onPressed: () async {
                // set the app's language to Finnish using the Get package
                await Get.updateLocale(const Locale('fi'));
                // close the dialog
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: const Text('French'),
              onPressed: () async {
                // set the app's language to French using the Get package
                await Get.updateLocale(const Locale('fr'));
                // close the dialog
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: const Text('Hungarian'),
              onPressed: () async {
                // set the app's language to Hungarian using the Get package
                await Get.updateLocale(const Locale('hu'));
                // close the dialog
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: const Text('Indonesian'),
              onPressed: () async {
                // set the app's language to Indonesian using the Get package
                await Get.updateLocale(const Locale('id'));
                // close the dialog
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: const Text('Italian'),
              onPressed: () async {
                // set the app's language to Italian using the Get package
                await Get.updateLocale(const Locale('it'));
                // close the dialog
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: const Text('Japanese'),
              onPressed: () async {
                // set the app's language to Japanese using the Get package
                await Get.updateLocale(const Locale('ja'));
                // close the dialog
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: const Text('Lithuanian'),
              onPressed: () async {
                // set the app's language to Lithuanian using the Get package
                await Get.updateLocale(const Locale('lt'));
                // close the dialog
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: const Text('Latvian'),
              onPressed: () async {
                // set the app's language to Latvian using the Get package
                await Get.updateLocale(const Locale('lv'));
                // close the dialog
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: const Text('Dutch'),
              onPressed: () async {
                // set the app's language to Dutch using the Get package
                await Get.updateLocale(const Locale('nl'));
                // close the dialog
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: const Text('Polish'),
              onPressed: () async {
                // set the app's language to Polish using the Get package
                await Get.updateLocale(const Locale('pl'));
                // close the dialog
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: const Text('Portuguese'),
              onPressed: () async {
                // set the app's language to Portuguese using the Get package
                await Get.updateLocale(const Locale('pt'));
                // close the dialog
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: const Text('Romanian'),
              onPressed: () async {
                // set the app's language to Romanian using the Get package
                await Get.updateLocale(const Locale('ro'));
                // close the dialog
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: const Text('Russian'),
              onPressed: () async {
                // set the app's language to Russian using the Get package
                await Get.updateLocale(const Locale('ru'));
                // close the dialog
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: const Text('Slovak'),
              onPressed: () async {
                // set the app's language to Slovak using the Get package
                await Get.updateLocale(const Locale('sk'));
                // close the dialog
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: const Text('Slovenian'),
              onPressed: () async {
                // set the app's language to Slovenian using the Get package
                await Get.updateLocale(const Locale('sl'));
                // close the dialog
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: const Text('Swedish'),
              onPressed: () async {
                // set the app's language to Swedish using the Get package
                await Get.updateLocale(const Locale('sv'));
                // close the dialog
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: const Text('Turkish'),
              onPressed: () async {
                // set the app's language to Turkish using the Get package
                await Get.updateLocale(const Locale('tr'));
                // close the dialog
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: const Text('Ukrainian'),
              onPressed: () async {
                // set the app's language to Ukrainian using the Get package
                await Get.updateLocale(const Locale('uk'));
                // close the dialog
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: const Text('Chinese'),
              onPressed: () async {
                // set the app's language to Chinese using the Get package
                await Get.updateLocale(const Locale('zh'));
                // close the dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
