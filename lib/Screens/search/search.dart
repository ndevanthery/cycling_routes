import 'package:cycling_routes/Models/route_m.dart';
import 'package:cycling_routes/Services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../../Models/user_m.dart';
import '../../Shared/components/route_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<RouteM> myRoutes = [];
  @override
  void didChangeDependencies() {
    var user = Provider.of<UserM?>(context);
    DatabaseService myService = DatabaseService(uid: user!.uid);
    myService.getAdminRoutes().then((value) => setState(() {
          myRoutes = value;
        }));

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (myRoutes.isEmpty) {
      return Text("No routes available for now ! ");
    }
    return GridView.count(
      crossAxisCount: 2,
      children: [
        ...myRoutes
            .map((e) => RouteCard(
                  route: e,
                  isAdmin: false,
                ))
            .toList()
      ],
    );
  }
}
