import 'package:latlong2/latlong.dart';

class TrafficJamM {
  final String? uid;

  dynamic description = '';
  DateTime? date;
  LatLng place;
  bool isValidated;

  TrafficJamM(
      {this.uid,
      this.description,
      this.date,
      required this.place,
      required this.isValidated});
}
