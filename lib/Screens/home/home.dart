import 'package:cycling_routes/Screens/map/mapView.dart';
import 'package:cycling_routes/Screens/profile/Profile.dart';
import 'package:cycling_routes/Screens/search/search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Services/auth.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  final List<Widget> _pages = <Widget>[
    const SearchPage(),
    MapPage(),
    const ProfilePage(),
    Container(child: const Center(child: Text("Settings"))),
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
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () async {
              await loginManager.signOut(context);
            },
            icon: const Icon(Icons.person),
            label: const Text('Logout'),
          )
        ],
      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex), //New
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30), topLeft: const Radius.circular(30)),
        child: BottomNavigationBar(
          items: [
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: Colors.black,
              ),
              label: "Search",
            ),
            const BottomNavigationBarItem(
                icon: const Icon(Icons.browse_gallery), label: "Map"),
            const BottomNavigationBarItem(
                icon: Icon(Icons.home), label: "Profile"),
            const BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "Settings"),
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
