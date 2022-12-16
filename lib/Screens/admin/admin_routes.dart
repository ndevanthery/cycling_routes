import 'package:cycling_routes/Services/database.dart';
import 'package:cycling_routes/Shared/components/route_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Models/route_m.dart';
import '../../Services/auth.dart';

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
    Auth loginManager = Provider.of<Auth>(context, listen: false);
    DatabaseService myService =
        DatabaseService(uid: loginManager.getUser()!.uid);
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

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        crossAxisCount: 2,
        children: [
          ...myRoutes
              .map((e) => RouteCard(
                  route: e,
                  isAdmin: true,
                  remove: (RouteM removed) {
                    setState(() {
                      myRoutes.remove(removed);
                    });
                  },
                  update: () {
                    setState(() {});
                  }))
              .toList()
        ],
      ),
    );
  }
}
