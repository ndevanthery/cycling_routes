import 'package:cycling_routes/Screens/map/mapView.dart';
import 'package:cycling_routes/Screens/profile/Profile.dart';
import 'package:cycling_routes/Screens/search/search.dart';
import 'package:cycling_routes/Services/auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  int _selectedIndex = 0;
  List<Widget> _pages = <Widget>[
    SearchPage(),
    MapPage(),
    ProfilePage(),
    Container(child: Center(child: Text("Settings"))),
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
        actions: <Widget>[
          TextButton.icon(
            onPressed: () async {
              await _auth.signOut();
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
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: Colors.black,
              ),
              label: "Search",
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.browse_gallery), label: "Map"),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Profile"),
            BottomNavigationBarItem(
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
