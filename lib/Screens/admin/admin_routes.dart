import 'package:cycling_routes/Services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../Models/route_m.dart';

class AdminRouteList extends StatefulWidget {
  const AdminRouteList({Key? key}) : super(key: key);

  @override
  State<AdminRouteList> createState() => _AdminRouteListState();
}

class _AdminRouteListState extends State<AdminRouteList> {
  List<RouteM> myRoutes = [];
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  void didChangeDependencies() {
    DatabaseService myService = DatabaseService(uid: null);

    myService.getAdminRoutes().then((value) => setState(() {
          myRoutes = value;
        }));

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (myRoutes.isEmpty) {
      return Text("You need to create a route first ! ");
    }
    return ListView(
      children: [
        ...myRoutes
            .map((e) => Container(
                  margin: EdgeInsets.all(8),
                  color: Colors.red,
                  child: Text(
                      "ROUTE : ${e.uid} CREATED BY ${e.uidCreator} , Time : ${e.duration} seconds , distance : ${e.distance} m"),
                ))
            .toList()
      ],
    );
  }
}
