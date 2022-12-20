// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:cycling_routes/Models/route_m.dart';
import 'package:cycling_routes/Services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../Services/auth.dart';
import '../../Shared/components/route_card.dart';

//##############################

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<RouteM> allRoutes = [];
  @override
  void didChangeDependencies() {
    Auth loginManager = Provider.of<Auth>(context, listen: false);
    DatabaseService myService =
        DatabaseService(uid: loginManager.getUser()!.uid);

    // Get all routes
    myService.getRoutes().then((value) => setState(() {
          allRoutes = value;
        }));

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (allRoutes.isEmpty) {
      return Text(AppLocalizations.of(context)!.noRoutes);
    }
    return GridView.count(
      crossAxisCount: 2,
      children: <Widget>[
        TextField(
          onChanged: (value) => _runFilter(value),
          decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.searchRoute,
              suffixIcon: Icon(Icons.search)),
        ),
        ...allRoutes
            .map((e) => RouteCard(
                  route: e,
                  isAdmin: false,
                  remove: (RouteM removed) {
                    setState(() {
                      allRoutes.remove(removed);
                    });
                  },
                ))
            .toList(),
      ],
    );
  }
}

//Filter
void _runFilter(String inputText) {
  List<RouteM> results = [];
  if (inputText.isEmpty) {
    results = _SearchPageState().allRoutes;
  } else {
    results = _SearchPageState()
        .allRoutes
        .where((Routes) =>
            Routes.name!.toLowerCase().contains(inputText.toLowerCase()))
        .toList();
  }
}
