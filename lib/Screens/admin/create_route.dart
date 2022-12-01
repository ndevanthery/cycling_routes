import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cycling_routes/Models/route_m.dart';
import 'package:cycling_routes/Services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../Models/user_m.dart';

class CreateRoute extends StatefulWidget {
  CreateRoute({Key? key}) : super(key: key);
  @override
  State<CreateRoute> createState() => _CreateRouteState();
}

class _CreateRouteState extends State<CreateRoute> {
  Position? _position;
  late LatLng _clicked;
  bool switchValue = false;
  List<LatLng> points = [];
  //List<LatLng> myRoute = [];
  RouteM myRouteM = RouteM(routePoints: []);
  UserM? user;

  void _getCurrentLocation() async {
    Position position = await _determinePosition();
    setState(() {
      _position = position;
    });
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
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    _clicked = LatLng(0, 0);

    _getCurrentLocation();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    user = Provider.of<UserM?>(context);

    super.didChangeDependencies();
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
                  points.add(point);
                  print(points);
                });
                print(point.toString());
              },
              minZoom: 9,
              maxZoom: 18,
              zoom: 9,
              center: LatLng(46.5480234, 6.4022017),
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
                  strokeWidth: 3,
                  color: Colors.yellow,
                  points: [...myRouteM.routePoints!],
                ),
              ],
            ),
            MarkerLayerOptions(markers: [
              //retrieve user position (if he accepts to give it) and display a bike on the map
              Marker(
                point: LatLng(_position == null ? 0 : _position!.latitude,
                    _position == null ? 0 : _position!.longitude),
                width: 80,
                height: 80,
                builder: (context) => Icon(
                  Icons.place,
                  color: Colors.red,
                ),
              ),
              ...points.map((e) {
                return Marker(
                  point: e,
                  width: 200,
                  height: 200,
                  builder: (context) => Icon(
                    Icons.place,
                    color: Colors.green,
                  ),
                );
              }).toList(),

              if (myRouteM.routePoints!.isNotEmpty)
                Marker(
                  point: myRouteM.routePoints!.first,
                  width: 80,
                  height: 80,
                  builder: (context) => Icon(Icons.directions_bike),
                ),

              //canvas/attempt to make start/end point

              if (myRouteM.routePoints!.isNotEmpty)
                Marker(
                  point: myRouteM.routePoints!.last,
                  width: 80,
                  height: 80,
                  builder: (context) => Icon(
                    Icons.flag,
                    color: Colors.green,
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
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () async {
                      var getRoute = await _getRoute(points);
                      setState(() {
                        myRouteM = getRoute;
                      });
                    },
                    child: Text("calculate"),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        myRouteM.routePoints = [];
                        points = [];
                      });
                    },
                    child: Text("clear"),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _dialSave();
                        //saveRoute();
                        //myRouteM.routePoints = [];
                        //points = [];
                      });
                    },
                    child: Text("save"),
                  ),
                ],
              )),
        ),
      ],
    );
  }

  Future<RouteM> _getRoute(List<LatLng> myRoute) async {
    RouteM myReturnRoute = RouteM(routePoints: []);
    if (myRoute == []) {
      return myReturnRoute;
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
      var summary = feature[0]['properties']!['summary']!;
      myReturnRoute.distance = summary['distance'];
      myReturnRoute.duration = summary['duration'];

      for (int i = 0; i < coordinates.length; i++) {
        myReturnRoute.routePoints!
            .add(LatLng(coordinates[i][1], coordinates[i][0]));
      }
    }
    return myReturnRoute;
  }

  void saveRoute() {
    var dbService = DatabaseService(uid: user!.uid);
    myRouteM.uidCreator = user!.uid;

    dbService.addRoute(myRouteM);
  }

  Future<void> _dialSave() {
    TextEditingController myController = TextEditingController();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Save"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Enter the name of the route"),
                TextField(
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
                "cancel",
                style: const TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                "save",
                style: const TextStyle(color: Colors.black),
              ),
              onPressed: () {
                setState(() {
                  myRouteM.name = myController.text;
                  print(myRouteM);

                  saveRoute();
                  myRouteM.routePoints = [];
                  points = [];
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
