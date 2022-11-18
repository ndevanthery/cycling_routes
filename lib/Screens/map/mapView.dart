import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Position? _position;

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
    _getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("map display"),
        ),
        body: FlutterMap(
          options: MapOptions(
              minZoom: 7,
              maxZoom: 18,
              zoom: 8,
              center: LatLng(46.5480234, 6.4022017),
              maxBounds: LatLngBounds(
                  LatLng(45.398181, 5.140242), LatLng(48.230651, 11.47757))),
          layers: [
            TileLayerOptions(
              urlTemplate:
                  'https://wmts.geo.admin.ch/1.0.0/ch.swisstopo.pixelkarte-farbe/default/current/3857/{z}/{x}/{y}.jpeg',
            ),
            PolylineLayerOptions(
              polylines: [
                Polyline(
                  strokeWidth: 3,
                  color: Colors.black,
                  points: [
                    LatLng(46.3808464, 6.8059153),
                    LatLng(46.4174536, 7.1895558),
                    LatLng(46.1855684, 7.3205926),
                  ],
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

              //canvas/attempt to make start/end point
              Marker(
                point: LatLng(46.3808464, 6.8059153),
                width: 80,
                height: 80,
                builder: (context) => Icon(Icons.directions_bike),
              ),

              Marker(
                point: LatLng(46.1855684, 7.3205926),
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
        ));
  }
}
