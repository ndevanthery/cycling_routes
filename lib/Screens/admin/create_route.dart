// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:cycling_routes/Models/route_m.dart';
import 'package:cycling_routes/Services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../Models/user_m.dart';
import '../../Services/auth.dart';

class CreateRoute extends StatefulWidget {
  const CreateRoute({Key? key}) : super(key: key);
  @override
  State<CreateRoute> createState() => _CreateRouteState();
}

class _CreateRouteState extends State<CreateRoute> {
  Position? _position;
  late LatLng _clicked;
  bool switchValue = false;
  List<LatLng> points = [];
  //List<LatLng> myRoute = [];
  RouteM myRouteM = RouteM(routePoints: [], isFav: false);
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
        return Future.error(AppLocalizations.of(context)!.locationDenied);
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(AppLocalizations.of(context)!.locationDeniedForever);
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
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Auth loginManager = Provider.of<Auth>(context, listen: false);

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
                  strokeWidth: 5,
                  color: Colors.red,
                  points: [...myRouteM.routePoints!],
                ),
              ],
            ),
            MarkerLayerOptions(markers: [
              //retrieve user position (if he accepts to give it) and display a bike on the map
              Marker(
                point: LatLng(_position == null ? 0 : _position!.latitude,
                    _position == null ? 0 : _position!.longitude),
                builder: (context) => const Icon(
                  Icons.place,
                  color: Colors.red,
                  size: 40,
                ),
              ),
              ...points.map((e) {
                return Marker(
                  point: e,
                  builder: (context) => const Icon(
                    Icons.place,
                    color: Colors.green,
                    size: 25,
                  ),
                );
              }).toList(),

              if (myRouteM.routePoints!.isNotEmpty)
                Marker(
                  point: myRouteM.routePoints!.first,
                  builder: (context) => const Icon(
                    Icons.directions_bike,
                    size: 40,
                  ),
                ),

              //canvas/attempt to make start/end point

              if (myRouteM.routePoints!.isNotEmpty)
                Marker(
                  point: myRouteM.routePoints!.last,
                  builder: (context) => const Icon(
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
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor: Color.fromRGBO(100, 100, 100, 1)),
                    onPressed: () async {
                      var getRoute = await _getRoute(points);
                      setState(() {
                        myRouteM = getRoute;
                      });
                    },
                    child: Text(AppLocalizations.of(context)!.calculate),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        myRouteM.routePoints = [];
                        points = [];
                      });
                    },
                    style: TextButton.styleFrom(
                        foregroundColor: Color.fromRGBO(100, 100, 100, 1)),
                    child: Text(AppLocalizations.of(context)!.clear),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _dialSave(loginManager.getUser()!.uid);
                        //saveRoute();
                        //myRouteM.routePoints = [];
                        //points = [];
                      });
                    },
                    style: TextButton.styleFrom(
                        foregroundColor: Color.fromRGBO(100, 100, 100, 1)),
                    child: Text(AppLocalizations.of(context)!.save),
                  ),
                ],
              )),
        ),
      ],
    );
  }

  Future<RouteM> _getRoute(List<LatLng> myRoute) async {
    RouteM myReturnRoute = RouteM(routePoints: [], isFav: false);
    if (myRoute == []) {
      return myReturnRoute;
    }
    List<String> myCoordinates =
        myRoute.map((e) => '[ ${e.longitude} , ${e.latitude}]').toList();

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

    if (response.statusCode == 200) {
      var jsonParsed = jsonDecode(response.body);
      var feature = jsonParsed['features']!;

      var coordinates = feature[0]['geometry']!['coordinates'];
      var summary = feature[0]['properties']!['summary']!;
      myReturnRoute.distance = summary['distance'] as double?;
      myReturnRoute.duration = summary['duration'];

      for (int i = 0; i < coordinates.length; i++) {
        myReturnRoute.routePoints!
            .add(LatLng(coordinates[i][1], coordinates[i][0]));
      }
      myReturnRoute.altitudePoints =
          await getAltitude(myReturnRoute.routePoints!);
    }
    return myReturnRoute;
  }

  Future<List<double>> getAltitude(List<LatLng> myCoordinates) async {
    List<double> responseList = [];
    print(myCoordinates.length);
    List<List<double>> myStrings =
        myCoordinates.map((e) => [e.latitude, e.longitude]).toList();
    var data = jsonEncode(myStrings);

    var response =
        await http.post(Uri.parse("https://elevation.racemap.com/api"),
            headers: {
              "Content-Type": "application/json",
            },
            body: data,
            encoding: Encoding.getByName("utf-8"));
    if (response.statusCode == 200) {
      List<dynamic> tempResp = jsonDecode(response.body);
      responseList = tempResp
          .map(
            (e) => e * 1.0 as double,
          )
          .toList();

      print(responseList);
    }
    return responseList;
  }

  void saveRoute(uid) {
    var dbService = DatabaseService(uid: uid);
    myRouteM.uidCreator = uid;

    dbService.addRoute(myRouteM);
  }

  Future<void> _dialSave(uid) {
    TextEditingController myController = TextEditingController();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.save),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(AppLocalizations.of(context)!.enterRouteName),
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
              onPressed: () async {
                setState(() {
                  myRouteM.name = myController.text;

                  saveRoute(uid);
                  myRouteM.routePoints = [];
                  points = [];
                });

                var response = await http.post(
                    Uri.parse("https://fcm.googleapis.com/fcm/send"),
                    headers: {
                      "Accept": 'application/json',
                      "Content-Type": "application/json",
                      'Authorization':
                          'key=AAAAhLiQcFY:APA91bGOsLmxAkiQcdTLtriv3tUYUn7Dcm7WzL8hWwt4CSOkWzu7WDIyWEAf_BsfqjE88gKmxL1CD_zEOuVAM6kfEcd0RqfAr6zqcdWJKApppSxnqQCmDt6Xyv-VdtzhvtVKNJNJEMhC'
                    },
                    body:
                        '{"to": "/topics/all","notification": {"title": "new route created","body": "The route ${myRouteM.name} was created","mutable_content": true,"sound": "Tri-tone"}}');

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
