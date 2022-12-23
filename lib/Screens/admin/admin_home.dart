import 'package:cycling_routes/Screens/admin/admin_jams.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../Services/auth.dart';
import '../../Shared/utils.dart';
import 'admin_routes.dart';
import 'create_route.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int _selectedIndex = 0;
  final List<Widget> _pages = <Widget>[
    const AdminRouteList(),
    AdminJamsPage(),
    CreateRoute(),
  ];

  @override
  Widget build(BuildContext context) {
    Auth loginManager = Provider.of<Auth>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        title: const Text(
          'RideOn',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                Utils.showLogoutConfirmDialog(
                    context,
                    AppLocalizations.of(context)!.logout,
                    AppLocalizations.of(context)!.confirmDisconnect,
                    AppLocalizations.of(context)!.logout2,
                    AppLocalizations.of(context)!.cancel3,
                    loginManager);
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.black,
              ))
        ],
      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex), //New
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.browse_gallery),
                label: AppLocalizations.of(context)!.myRoutes),
            BottomNavigationBarItem(icon: Icon(Icons.warning), label: "Jams"),
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: AppLocalizations.of(context)!.create),
          ],
          onTap: _onItemTapped,
          currentIndex: _selectedIndex,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
