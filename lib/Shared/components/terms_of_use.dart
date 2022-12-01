import 'package:flutter/material.dart';

class TermOfUse extends StatelessWidget {
  const TermOfUse({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      color: Colors.transparent,
      width: double.infinity,
      child: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Icon(
            Icons.task_alt,
            color: Colors.black87,
          ),
          SizedBox(
            width: 8.0,
          ),
          Text(
            'I accepte the term of use',
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 12.0),
          ),
        ],
      )),
    );
  }
}
