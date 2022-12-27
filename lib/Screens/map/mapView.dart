import 'dart:convert';
import 'package:cycling_routes/Models/route_m.dart';
import 'package:cycling_routes/Models/trafficjam_m.dart';
import 'package:cycling_routes/Services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MapPage extends StatefulWidget {
  RouteM? route;
  MapPage({Key? key, this.route}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Position? _position;
  bool switchValue = false;
  bool isUnmount = false;
  List<LatLng> myRoute = [];
  LatLng? _clicked = null;
  List<TrafficJamM> jams = [];

  void _getCurrentLocation() async {
    Position position = await _determinePosition();

    print(isUnmount);
    if (!isUnmount) {
      setState(() {
        _position = position;
      });
    }
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    } // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    print(await Geolocator.getCurrentPosition());
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    if (widget.route != null) {
      myRoute = widget.route!.routePoints!;
    }

    _getCurrentLocation();
    DatabaseService myService = DatabaseService();
    myService.getTrafficJams().then((value) =>
        jams = value.where((element) => element.isValidated == true).toList());
    super.initState();
  }

  @override
  void dispose() {
    isUnmount = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            body: FlutterMap(
          options: MapOptions(
              onTap: (tapPosition, point) {
                setState(() {
                  _clicked = point;
                });
                print(point.toString());
              },
              minZoom: 9,
              maxZoom: 18,
              zoom: 9,
              center: myRoute.isEmpty
                  ? LatLng(46.5480234, 6.4022017)
                  : myRoute.first,
              maxBounds: LatLngBounds(
                  LatLng(45.398181, 5.140242), LatLng(48.230651, 11.47757))),
          layers: [
            switchValue
                ? TileLayerOptions(
                    urlTemplate:
                        'https://wmts.geo.admin.ch/1.0.0/ch.swisstopo.strassenkarte-200/default/current/3857/{z}/{x}/{y}.png',
                  )
                : TileLayerOptions(
                    urlTemplate:
                        'https://wmts.geo.admin.ch/1.0.0/ch.swisstopo.pixelkarte-farbe/default/current/3857/{z}/{x}/{y}.jpeg',
                  ),

            PolylineLayerOptions(
              polylines: [
                Polyline(
                  strokeWidth: 5,
                  color: Colors.red,
                  points: [...myRoute],
                ),
              ],
            ),
            MarkerLayerOptions(markers: [
              ...jams.map((e) => Marker(
                    point: e.place,
                    builder: (context) => IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        _dialProblem(e);
                      },
                      icon: Icon(
                        Icons.warning,
                        color: Colors.orange,
                      ),
                    ),
                  )),
              //retrieve user position (if he accepts to give it) and display a bike on the map
              Marker(
                point: LatLng(_position == null ? 0 : _position!.latitude,
                    _position == null ? 0 : _position!.longitude),
                builder: (context) => Icon(
                  Icons.place,
                  color: Colors.red,
                ),
              ),
              if (_clicked != null)
                Marker(
                  point: _clicked!,
                  builder: (context) => Icon(
                    Icons.place,
                    color: Colors.red,
                    size: 40,
                  ),
                ),

              if (myRoute.isNotEmpty)
                Marker(
                  point: myRoute.first,
                  width: 150,
                  height: 150,
                  builder: (context) => Icon(
                    Icons.directions_bike,
                    size: 40,
                  ),
                ),

              //canvas/attempt to make start/end point

              if (myRoute.isNotEmpty)
                Marker(
                  point: myRoute.last,
                  builder: (context) => Icon(
                    Icons.flag,
                    color: Colors.green,
                    size: 40,
                  ),
                ),
            ]),

            // canvas/attempt to make a route
          ],
        )),
        Switch(
            value: switchValue,
            onChanged: (val) {
              setState(() {
                switchValue = val;
              });
            }),
        if (_clicked != null)
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      _dialNotifyProblem(context).then((value) => setState(
                            () {},
                          ));
                    },
                    child: Text(AppLocalizations.of(context)!.notifyTrouble)),
              )),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _clicked = null;
                      });
                    },
                    child: Text(AppLocalizations.of(context)!.clear)),
              )),
            ]),
          ),
      ],
    );
  }

  Future<List<LatLng>> _getRoute(List<LatLng> myRoute) async {
    List<LatLng> myReturn = [];
    if (myRoute == []) {
      return myReturn;
    }
    List<String> myCoordinates =
        myRoute.map((e) => '[ ${e.longitude} , ${e.latitude}]').toList();

    print(myCoordinates.join(','));
    var response = await http.post(
        Uri.parse(
            "https://api.openrouteservice.org/v2/directions/cycling-regular/geojson"),
        headers: {
          "Accept":
              'application/json, application/geo+json, application/gpx+xml, img/png; charset=utf-8',
          "Content-Type": "application/json",
          'Authorization':
              '5b3ce3597851110001cf6248a744e0e2eadf4594b08f961125b1131d'
        },
        body: '{"coordinates":[ ${myCoordinates.join(',')}]}',
        encoding: Encoding.getByName("utf-8"));

    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonParsed = jsonDecode(response.body);
      var feature = jsonParsed['features']!;

      var coordinates = feature[0]['geometry']!['coordinates'];

      for (int i = 0; i < coordinates.length; i++) {
        myReturn.add(LatLng(coordinates[i][1], coordinates[i][0]));
      }
    }
    return myReturn;
  }

  Future<void> _dialNotifyProblem(uid) {
    TextEditingController myController = TextEditingController();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.notifyTrouble),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("${AppLocalizations.of(context)!.describeYourProblem}:"),
                TextField(
                  minLines: 1,
                  maxLines: 10,
                  textInputAction: TextInputAction.newline,
                  controller: myController,
                ),
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
                AppLocalizations.of(context)!.cancel,
                style: const TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                AppLocalizations.of(context)!.save,
                style: const TextStyle(color: Colors.black),
              ),
              onPressed: () {
                setState(() {
                  DatabaseService myService = DatabaseService(uid: null);
                  myService.addTrafficJam(new TrafficJamM(
                      description: myController.text,
                      date: DateTime.now(),
                      place: _clicked!,
                      isValidated: false));
                  _clicked = null;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _dialProblem(TrafficJamM jam) {
    TextEditingController myController = TextEditingController();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.problemDetail),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  "${AppLocalizations.of(context)!.description} : ",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(jam.description),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "${AppLocalizations.of(context)!.at} ${jam.date!.hour.toString().padLeft(2, '0')} ${jam.date!.minute.toString().padLeft(2, '0')}",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  DateFormat.yMMMMd(Get.locale!.languageCode).format(jam.date!),
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
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
                AppLocalizations.of(context)!.ok,
                style: const TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
