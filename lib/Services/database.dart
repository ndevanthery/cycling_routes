import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cycling_routes/Models/route_m.dart';
import 'package:cycling_routes/Models/user_m.dart';
import 'package:cycling_routes/Services/auth_exception_handler.dart';
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
    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(userM.uid)
        .set({
      'email': userM.email,
      'firstname': userM.firstname,
      'lastname': userM.lastname,
      'address': userM.address,
      'npa': userM.npa,
      'localite': userM.localite,
      'birthday': userM.birthday,
      'favRoutes': userM.favRoutes,
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
      "name": route.name,
    };
    return await routeCollect.add(myRouteMap);
  }

  Future<bool> updateRouteName(String uid, String newName) async {
    await FirebaseFirestore.instance
        .collection('Routes')
        .doc(uid)
        .update({'name': newName});
    return true;
  }

  //Add or remove a fav route
  Future<ExceptionStatus> manageFavs(RouteM route, UserM user) async {
    ExceptionStatus status = ExceptionStatus.pending;
    //Check if the route we want to add is already a fav
    //If not in then we add it,
    //If in then we remove it
    if (!user.favRoutes.contains(route.uid!)) {
      //Add new fav into user in app
      user.favRoutes.add(route.uid!);
      //Change isfav property of the route to true
      route.isFav = true;
    } else {
      user.favRoutes.remove(route.uid!);
      route.isFav = false;
    }

    try {
      //Save into Firestore
      await updateUserData(user).then((value) {
        log('favs list of ${user.email} : updated ');
        status = ExceptionStatus.successful;
      });
    } on FirebaseException catch (e) {
      status = ExceptionHandler.handleAuthException(e);
    }
    return status;
  }

  Future<List<RouteM>> getAdminRoutes() async {
    var getRoutes = await routeCollect.get();
    var myDocs = getRoutes.docs.where((element) => element['creator'] == uid);

    List<RouteM> myRouteList = [];
    for (var doc in myDocs) {
      var myData = doc.data()! as Map<String, dynamic>;
      List<dynamic> myPoints = myData['route'];
      List<LatLng> myLatLng =
          myPoints.map((point) => LatLng(point['lat'], point['long'])).toList();
      myRouteList.add(RouteM(
          uid: doc.id,
          uidCreator: myData['creator'],
          distance: myData['distance'] as double,
          duration: myData['duration'],
          name: myData['name'],
          routePoints: myLatLng,
          isFav: false));
    }

    return myRouteList;
  }

  //Stream to listen for User Data Changes
  Stream<QuerySnapshot> get user {
    return userCollect.snapshots();
  }

  Future<List<RouteM>> getRoutes(UserM user) async {
    List<RouteM> myRouteList = [];

    //Get all existing routes's doc
    var getRoutes = await routeCollect.get();
    var myDocs = getRoutes.docs;

    //Get the list of favs route from user
    var favsRoutes = user.favRoutes;

    //For each doc retreive routes information
    for (var doc in myDocs) {
      var myData = doc.data()! as Map<String, dynamic>;
      bool isFav = false; //By default it's not a fav route

      //Check if the id of the route is in the fav list of the user
      for (var fav in favsRoutes) {
        if (doc.id.compareTo(fav) == 0) {
          isFav = true;
        }
      }
      // ?? never used ??
      List<dynamic> myPoints = myData['route'];
      List<LatLng> myLatLng =
          myPoints.map((point) => LatLng(point['lat'], point['long'])).toList();
      //Finally add the route with its info into the list
      myRouteList.add(RouteM(
          uid: doc.id,
          uidCreator: myData['creator'],
          distance: myData['distance'] as double?,
          duration: myData['duration'],
          name: myData['name'],
          routePoints: myLatLng,
          isFav: isFav));
    }

    return myRouteList;
  }

  Future<void> deleteRoute(RouteM route) async {
    await routeCollect.doc(route.uid).delete();
  }

  Future<ExceptionStatus> deleteUser(UserM user) async {
    dynamic status = ExceptionStatus.pending;
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .delete();
      status = ExceptionStatus.dataDeleted;
    } on FirebaseException catch (e) {
      status = ExceptionHandler.handleAuthException(e);
    }
    return status;
  }
}
