import 'package:flutter/material.dart';

class PoweredBy extends StatelessWidget {
  const PoweredBy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3.0),
      color: Colors.transparent,
      width: double.infinity,
      height: 40.0,
      child: const Center(
          child: Text(
        'Powered by HES-SO',
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),
      )),
    );
  }
}
