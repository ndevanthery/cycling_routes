import 'package:latlong2/latlong.dart';

class RouteM {
  final String? uid;

  String? name;
  String? uidCreator;
  List<LatLng>? routePoints;
  double? distance;
  double? duration;
  bool isFav;

  RouteM(
      {this.name,
      this.uid,
      this.uidCreator,
      this.routePoints,
      this.distance,
      this.duration,
      required this.isFav} );
}
