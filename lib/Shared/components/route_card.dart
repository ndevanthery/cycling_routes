import 'package:cycling_routes/Models/route_m.dart';
import 'package:cycling_routes/Services/database.dart';
import 'package:cycling_routes/Shared/components/route_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Models/user_m.dart';

class RouteCard extends StatefulWidget {
  RouteM route;
  bool isAdmin;
  Function? remove;
  RouteCard({Key? key, required this.route, required this.isAdmin, this.remove})
      : super(key: key);
  @override
  State<RouteCard> createState() => _RouteCardState();
}

class _RouteCardState extends State<RouteCard> {
  UserM? user;

  @override
  void didChangeDependencies() {
    user = Provider.of<UserM?>(context);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RouteDetails(
                route: widget.route,
              ),
            ));
      },
      onLongPress: widget.isAdmin
          ? () {
              _dialDeleteRoute();
            }
          : null,
      child: Container(
        padding: EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: const Image(
                fit: BoxFit.cover,
                image: AssetImage("assets/velo_tour.jpg"),
                width: 170,
              ),
            ),
            Text(
              "${widget.route.name}",
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            Text(
              "Dist: ${widget.route.distance} Time: ${widget.route.duration} sec",
              overflow: TextOverflow.clip,
            )
          ],
        ),
      ),
    );
  }

  Future<void> _dialDeleteRoute() {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Are you sure you want to delete this route"),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          contentPadding: const EdgeInsets.fromLTRB(24, 15, 24, 15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          actions: <Widget>[
            TextButton(
              child: Text(
                "cancel",
                style: const TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                "delete",
                style: const TextStyle(color: Colors.black),
              ),
              onPressed: () async {
                DatabaseService serv = DatabaseService(uid: null);
                await serv.deleteRoute(widget.route);
                widget.remove!(widget.route);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
