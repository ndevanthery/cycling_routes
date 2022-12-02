// ignore: file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cycling_routes/Shared/components/route_card.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 30, 30, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                imageProfile(),
                const SizedBox(
                  height: 20,
                )
                /*CircleAvatar(
                  radius: 62,
                  backgroundColor: Colors.grey[700],
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/profile_pic.png'),
                    radius: 60,
                  ),
                ),*/
                ,
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    shape: const CircleBorder(),
                  ),
                  onPressed: () {},
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.settings,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "FIRSTNAME",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              "LASTNAME",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const Text("ADDRESS"),
            const Text("NPA/TOWN"),
            const Text("EMAIL"),
            //     RouteCard(isAdmin: true, route: ,),
          ],
        ),
      ),
    );
  }

  Widget imageProfile() {
    return Stack(children: <Widget>[
      CircleAvatar(
          radius: 62.0,
          // ignore: unnecessary_null_comparison
          backgroundImage: imageFile == null
              ? const AssetImage("assets/profile_pic.png") as ImageProvider
              : FileImage(File(imageFile!.path))),
      Positioned(
        bottom: 20.0,
        right: 20.0,
        child: InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: ((builder) => bottomSheet()),
            );
          },
          child: const Icon(Icons.camera_alt,
              color: Color.fromARGB(255, 255, 255, 255), size: 28.0),
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
          const Text(
            "Choose Profile picture",
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
              label: const Text("Camera"),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              label: const Text("Gallery"),
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
