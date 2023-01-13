import 'package:cycling_routes/Screens/map/mapView.dart';
import 'package:cycling_routes/Services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../Models/route_m.dart';

class RouteDetails extends StatefulWidget {
  RouteM route;
  bool isAdmin;
  RouteDetails({Key? key, required this.route, required this.isAdmin})
      : super(key: key);

  @override
  State<RouteDetails> createState() => _RouteDetailsState();
}

class _RouteDetailsState extends State<RouteDetails> {
  bool nameEdited = false;
  TextEditingController myNameController = TextEditingController();
  int elevationDiff = 0;

  @override
  void initState() {
    myNameController.text = widget.route.name!;
    var alt = widget.route.altitudePoints!;
    alt.sort();

    elevationDiff = (alt.last - alt.first).toInt();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.routeDescription),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(children: [
          nameEdited
              ? TextField(
                  controller: myNameController,
                )
              : Text(
                  "${widget.route.name}",
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w600),
                ),
          widget.isAdmin
              ? ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      if (nameEdited == true) {
                        DatabaseService myService = DatabaseService(uid: null);
                        myService.updateRouteName(
                            widget.route.uid!, myNameController.text);
                      }
                      widget.route.name = myNameController.text;
                      nameEdited = !nameEdited;
                    });
                  },
                  icon: nameEdited
                      ? const Icon(Icons.save)
                      : const Icon(Icons.edit),
                  label: nameEdited
                      ? Text(AppLocalizations.of(context)!.saveName)
                      : Text(AppLocalizations.of(context)!.editName),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(100, 100, 100, 1)),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 50),
            child: GridView.count(
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              shrinkWrap: true,
              crossAxisCount: 2,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "$elevationDiff m",
                          style: const TextStyle(
                              fontSize: 18,
                              letterSpacing: 1.1,
                              fontWeight: FontWeight.w500),
                        ),
                        const Icon(
                          Icons.landscape,
                          size: 50,
                        ),
                      ]),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "${(widget.route.distance! / 1000).toStringAsFixed(1)} km",
                          style: const TextStyle(
                              fontSize: 18,
                              letterSpacing: 1.1,
                              fontWeight: FontWeight.w500),
                        ),
                        const Icon(
                          Icons.time_to_leave,
                          size: 50,
                        ),
                      ]),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "${(widget.route.duration! / 60).toStringAsFixed(0)} min",
                          style: const TextStyle(
                              fontSize: 18,
                              letterSpacing: 1.1,
                              fontWeight: FontWeight.w500),
                        ),
                        const Icon(
                          Icons.hourglass_top,
                          size: 50,
                        ),
                      ]),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Level ${(widget.route.duration! * elevationDiff / 100) / 60 ~/ 30}",
                          style: const TextStyle(
                              fontSize: 18,
                              letterSpacing: 1.1,
                              fontWeight: FontWeight.w500),
                        ),
                        const Icon(
                          Icons.pedal_bike,
                          size: 50,
                        ),
                      ]),
                ),
              ],
            ),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Scaffold(
                              appBar: AppBar(
                                title: Text(widget.route.name!),
                              ),
                              body: MapPage(
                                route: widget.route,
                              ),
                            )));
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(100, 100, 100, 1)),
              child: Text(AppLocalizations.of(context)!.start)),
        ]),
      ),
    );
  }
}
