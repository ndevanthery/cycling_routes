import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Services/auth.dart';
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
<<<<<<< HEAD
        actions: <Widget>[
          ElevatedButton.icon(
            onPressed: () async {
              await loginManager.signOut(context);
            },
            icon: const Icon(Icons.person),
            label: const Text('Logout'),
          )
        ],
=======
>>>>>>> 55a83df (Deleting Flatbutton ( Deprecated ))
      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex), //New
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.browse_gallery), label: "My routes"),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Create"),
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
