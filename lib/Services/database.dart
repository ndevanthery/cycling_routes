import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cycling_routes/Models/route_m.dart';
import 'package:cycling_routes/Models/user_m.dart';
import 'package:latlong2/latlong.dart';

class DatabaseService {
  final String? uid;

  //Constructor
  DatabaseService({required this.uid});

  //Collections Refs
  final CollectionReference userCollect =
      FirebaseFirestore.instance.collection('Users');
  final CollectionReference routeCollect =
      FirebaseFirestore.instance.collection('Routes');

  //Create User Doc at sign in
  //Or update their data
  Future updateUserData(UserM userM) async {
    return await userCollect.doc(uid).set({
      'email': userM.email,
      'firstname': userM.firstname,
      'lastname': userM.lastname,
      'address': userM.address,
      'npa': userM.npa,
      'localite': userM.localite,
      'birthday': userM.birthday,
      'role': userM.role,
    });
  }

  Future addRoute(RouteM route) async {
    List<Map<String, double>> myPoints = route.routePoints!
        .map((e) => {"lat": e.latitude, "long": e.longitude})
        .toList();
    Map<String, dynamic> myRouteMap = {
      "creator": route.uidCreator,
      "route": myPoints,
      "distance": route.distance,
      "duration": route.duration,
    };
    return await routeCollect.add(myRouteMap);
  }

  Future<List<RouteM>> getAdminRoutes() async {
    var getRoutes = await routeCollect.get();
    var myDocs = getRoutes.docs;
    List<RouteM> myRouteList = [];
    myDocs.forEach((doc) {
      var myData = doc.data()! as Map<String, dynamic>;
      List<dynamic> myPoints = myData['route'];
      List<LatLng> myLatLng =
          myPoints.map((point) => LatLng(point['lat'], point['long'])).toList();
      myRouteList.add(RouteM(
          uid: doc.id,
          uidCreator: myData['creator'],
          distance: myData['distance'],
          duration: myData['duration'],
          routePoints: []));
    });

    return myRouteList;
  }

  //Stream to listen for User Data Changes
  Stream<QuerySnapshot> get user {
    return userCollect.snapshots();
  }
}
