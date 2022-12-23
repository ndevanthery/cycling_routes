import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Get.theme.scaffoldBackgroundColor,
      child: const Center(
        child: SpinKitChasingDots(
          color: Colors.amberAccent,
          size: 50.0,
        ),
      ),
    );
  }
}
