// ignore_for_file: file_names

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Shared/constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? imageFileUrl;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    SharedPreferences.getInstance().then((value) => setState(() {
          imageFileUrl = value.getString('profilePic');
        }));

    super.initState();
  }

  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController npaController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  _buildTextField(TextEditingController controller, icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.black),
        decoration: textInputDecoration.copyWith(
            fillColor: Colors.white,
            hintText: controller.text,
            prefixIcon: Icon(
              icon,
              color: Colors.black,
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Padding(
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
                            Text(user['birthday'],
                                style: const TextStyle(fontSize: 20)),
                            const SizedBox(height: 15.0),
                            Text(user['address'],
                                style: const TextStyle(fontSize: 20)),
                            const SizedBox(height: 15.0),
                            Text(user['npa'] + ' ' + user['localite'],
                                style: const TextStyle(fontSize: 20)),
                            const SizedBox(height: 15.0),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: const CircleBorder(),
                              ),
                              onPressed: () {
                                firstnameController.text = user['firstname'];
                                lastnameController.text = user['lastname'];
                                birthdayController.text = user['birthday'];
                                addressController.text = user['address'];
                                npaController.text = user['npa'];
                                locationController.text = user['localite'];

                                showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color.fromRGBO(224, 224, 224, 1),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 30),
                                      child: ListView(
                                        shrinkWrap: true,
                                        children: <Widget>[
                                          _buildLabel(
                                              label:
                                                  AppLocalizations.of(context)!
                                                      .firstname),
                                          _buildTextField(firstnameController,
                                              Icons.person_outline_rounded),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          _buildLabel(
                                              label:
                                                  AppLocalizations.of(context)!
                                                      .lastname),
                                          _buildTextField(lastnameController,
                                              Icons.person_outline_rounded),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          _buildLabel(
                                              label:
                                                  AppLocalizations.of(context)!
                                                      .birthday),
                                          _buildTextField(birthdayController,
                                              Icons.location_on_outlined),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          _buildLabel(
                                              label:
                                                  AppLocalizations.of(context)!
                                                      .address),
                                          _buildTextField(addressController,
                                              Icons.location_on_outlined),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          _buildLabel(
                                              label:
                                                  AppLocalizations.of(context)!
                                                      .npa),
                                          _buildTextField(npaController,
                                              Icons.location_on_outlined),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          _buildLabel(
                                              label:
                                                  AppLocalizations.of(context)!
                                                      .locality),
                                          _buildTextField(locationController,
                                              Icons.location_on_outlined),
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
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser!.uid);

                                              docUser.update({
                                                "firstname":
                                                    firstnameController.text,
                                                "lastname":
                                                    lastnameController.text,
                                                "birthday":
                                                    birthdayController.text,
                                                "address":
                                                    addressController.text,
                                                "npa": npaController.text,
                                                "localite":
                                                    locationController.text
                                              }).whenComplete(() =>
                                                  Navigator.of(context).pop());
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
      ),
    );
  }

  Padding _buildLabel({label}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
      child: Text(
        label,
        style: const TextStyle(color: Colors.black, fontSize: 14),
      ),
    );
  }

  Widget imageProfile() {
    return Stack(children: <Widget>[
      CircleAvatar(
          radius: 90,
          // ignore: unnecessary_null_comparison
          backgroundImage: imageFileUrl == null
              ? const AssetImage("assets/profile_pic.png") as ImageProvider
              : FileImage(File(imageFileUrl!))),
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
            style: const TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(100, 100, 100, 1)),
                  icon: const Icon(Icons.camera),
                  onPressed: () {
                    takePhoto(ImageSource.camera);
                  },
                  label: Text(AppLocalizations.of(context)!.camera),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(100, 100, 100, 1)),
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
    var sharedPrefs = await SharedPreferences.getInstance();

    // ignore: deprecated_member_use
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      imageFileUrl = pickedFile!.path;
      sharedPrefs.setString('profilePic', imageFileUrl!);
    });
  }
}
