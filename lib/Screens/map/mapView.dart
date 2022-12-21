import 'dart:convert';
import 'package:cycling_routes/Models/route_m.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

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
              //retrieve user position (if he accepts to give it) and display a bike on the map
              Marker(
                point: LatLng(_position == null ? 0 : _position!.latitude,
                    _position == null ? 0 : _position!.longitude),
                width: 120,
                height: 120,
                builder: (context) => Icon(
                  Icons.place,
                  color: Colors.red,
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
