import 'package:latlong2/latlong.dart';

class RouteM {
  final String? uid;

  String? uidCreator;
  List<LatLng>? routePoints;
  double? distance;
  double? duration;

  RouteM(
      {this.uid,
      this.uidCreator,
      this.routePoints,
      this.distance,
      this.duration});
}
