import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cycling_routes/Models/user_m.dart';

class DatabaseService {
  final String uid;

  //Constructor
  DatabaseService({required this.uid});

  //Collections Refs
  final CollectionReference userCollect =
      FirebaseFirestore.instance.collection('Users');

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

  //Stream to listen for User Data Changes
  Stream<QuerySnapshot> get user {
    return userCollect.snapshots();
  }
}
