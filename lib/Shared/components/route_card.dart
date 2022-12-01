import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class RouteCard extends StatelessWidget {
  const RouteCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image(
              fit: BoxFit.cover,
              image: AssetImage("assets/velo_tour.jpg"),
              width: 170,
            ),
          ),
          Text(
            "Bulle to Fribourg",
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          Text(
            "Dist: 12km Time: 35min",
            overflow: TextOverflow.clip,
          )
        ],
      ),
    );
  }
}
