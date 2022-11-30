import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class MapPage extends StatefulWidget {
  List<LatLng>? points;
  MapPage({Key? key, this.points}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Position? _position;
  late LatLng _clicked;
  bool switchValue = false;
  List<LatLng> myRoute = [];

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
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    } // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    _clicked = LatLng(0, 0);
    widget.points = [
      LatLng(46.224410, 7.355230),
      LatLng(46.254379, 6.951690),
    ];

    if (widget.points != null) {
      _getRoute(widget.points!).then((value) => setState(() {
            //print(value);
/*             for (int i = 0; i < value.length; i++) {
              myRoute.add(value[i]);
            } */
            myRoute = value;
          }));
    }

    _getCurrentLocation();
    super.initState();
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
                  points: [...myRoute],
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

              Marker(
                point: _clicked,
                width: 200,
                height: 200,
                builder: (context) => Icon(
                  Icons.place,
                  color: Colors.green,
                ),
              ),
              if (myRoute.isNotEmpty)
                Marker(
                  point: myRoute.first,
                  width: 80,
                  height: 80,
                  builder: (context) => Icon(Icons.directions_bike),
                ),

              //canvas/attempt to make start/end point

              if (myRoute.isNotEmpty)
                Marker(
                  point: myRoute.last,
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
            })
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
}
