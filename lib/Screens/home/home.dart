import 'package:cycling_routes/Screens/map/mapView.dart';
import 'package:cycling_routes/Screens/profile/profile.dart';
import 'package:cycling_routes/Screens/search/search.dart';
import 'package:cycling_routes/Screens/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  final List<Widget> _pages = <Widget>[
    const SearchPage(),
    MapPage(),
    const ProfilePage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        title: const Text(
          'RideOn',
          style: TextStyle(color: Colors.black),
        ),
        // actions: <Widget>[
        //   TextButton.icon(
        //     onPressed: () async {
        //       await loginManager.signOut(context);
        //     },
        //     icon: const Icon(Icons.person),
        //     label: const Text('Logout'),
        //   )
        // ],
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
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
              label: AppLocalizations.of(context)!.search,
            ),
            BottomNavigationBarItem(
                icon: const Icon(Icons.browse_gallery),
                label: AppLocalizations.of(context)!.map),
            BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                label: AppLocalizations.of(context)!.profile),
            BottomNavigationBarItem(
                icon: const Icon(Icons.settings),
                label: AppLocalizations.of(context)!.settings),
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
