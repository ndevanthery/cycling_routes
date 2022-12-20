// ignore: file_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cycling_routes/Shared/components/route_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//import 'package:flutter/src/foundation/key.dart';
//import 'package:flutter/src/widgets/framework.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  PickedFile? imageFile;
  final ImagePicker _picker = ImagePicker();

  Color primaryColor = const Color.fromARGB(255, 255, 255, 255);
  Color secondaryColor = const Color.fromARGB(255, 126, 121, 121);

  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController npaController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  _buildTextField(TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: secondaryColor,
          border: Border.all(color: const Color.fromARGB(255, 151, 153, 156))),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            labelStyle: TextStyle(color: Colors.white),
            border: InputBorder.none),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 30, 30, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                imageProfile(),
                const SizedBox(
                  height: 200,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      final user = snapshot.data.data();
                      return Column(
                        children: [
                          Text(user['firstname'] + ' ' + user['lastname'],
                              style: const TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 15.0),
                          Text(user['address'],
                              style: const TextStyle(fontSize: 20)),
                          const SizedBox(height: 15.0),
                          Text(user['npa'] + ' ' + user['localite'],
                              style: const TextStyle(fontSize: 20)),
                          const SizedBox(height: 15.0),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              shape: const CircleBorder(),
                            ),
                            onPressed: () {
                              firstnameController.text = user['firstname'];
                              lastnameController.text = user['lastname'];
                              addressController.text = user['address'];
                              npaController.text = user['npa'];
                              locationController.text = user['localite'];

                              showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  child: Container(
                                    color: primaryColor,
                                    child: ListView(
                                      shrinkWrap: true,
                                      children: <Widget>[
                                        _buildTextField(
                                          firstnameController,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        _buildTextField(
                                          lastnameController,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        _buildTextField(
                                          addressController,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        _buildTextField(
                                          npaController,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        _buildTextField(
                                          locationController,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        ElevatedButton(
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .save),
                                          onPressed: () {
                                            final docUser = FirebaseFirestore
                                                .instance
                                                .collection('Users')
                                                .doc(FirebaseAuth
                                                    .instance.currentUser!.uid);

                                            docUser.update({
                                              "firstname":
                                                  firstnameController.text,
                                              "lastname":
                                                  lastnameController.text,
                                              "address": addressController.text,
                                              "npa": npaController.text,
                                              "localite":
                                                  locationController.text
                                            }).whenComplete(
                                                () => Navigator.pop(context));
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.edit,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    return const Material(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            //      RouteCard(isAdmin: true, route: ),
          ],
        ),
      ),
    );
  }

  Widget imageProfile() {
    return Stack(children: <Widget>[
      CircleAvatar(
          radius: 90,
          // ignore: unnecessary_null_comparison
          backgroundImage: imageFile == null
              ? const AssetImage("assets/profile_pic.png") as ImageProvider
              : FileImage(File(imageFile!.path))),
      Positioned(
        bottom: 30.0,
        right: 30.0,
        child: InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: ((builder) => bottomSheet()),
            );
          },
          child: const Icon(Icons.camera_alt,
              color: Color.fromARGB(255, 255, 255, 255), size: 32.0),
        ),
      ),
    ]);
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: 200.0,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Text(
            AppLocalizations.of(context)!.chooseProfilePicture,
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            ElevatedButton.icon(
              icon: const Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              label: Text(AppLocalizations.of(context)!.camera),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              label: Text(AppLocalizations.of(context)!.gallery),
            ),
          ])
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      imageFile = pickedFile!;
    });
  }
}
