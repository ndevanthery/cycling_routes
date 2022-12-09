import 'package:cycling_routes/Screens/map/mapView.dart';
import 'package:flutter/material.dart';

import '../../Models/route_m.dart';

class RouteDetails extends StatefulWidget {
  RouteM route;
  RouteDetails({Key? key, required this.route}) : super(key: key);

  @override
  State<RouteDetails> createState() => _RouteDetailsState();
}

class _RouteDetailsState extends State<RouteDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Route description"),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(children: [
          Text(
            "${widget.route.name}",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 50),
            child: GridView.count(
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              shrinkWrap: true,
              crossAxisCount: 2,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(children: [Text("ALTITUDE ( UNKNOWN !!! )")]),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(children: [
                    Text(
                        "${(widget.route.distance! / 1000).toStringAsFixed(1)} km")
                  ]),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(children: [
                    Text(
                        "${(widget.route.duration! / 60).toStringAsFixed(0)} min")
                  ]),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapPage(
                        route: widget.route,
                      ),
                    ));
              },
              child: Text("Start")),
        ]),
      ),
    );
  }
}
