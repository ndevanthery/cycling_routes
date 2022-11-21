import 'package:cycling_routes/Screens/map/mapView.dart';
import 'package:cycling_routes/Services/auth.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
   Home({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      appBar: AppBar(
        automaticallyImplyLeading :false,
        backgroundColor: Colors.yellow[100],
        elevation: 0.0,
        title: const Text('RideOn', style: TextStyle(color: Colors.black),),
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () async {
              await _auth.signOut();
            },
            icon: const Icon(Icons.person),
            label: const Text('Logout'),
          )
        ],
      ),
      body: TextButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MapView()));
          },
          child: Text("MAP")),
    );
  }
}
