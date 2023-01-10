import 'package:cycling_routes/Services/database.dart';
import 'package:cycling_routes/Shared/components/route_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../../Models/route_m.dart';
import '../../Services/auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AdminRouteList extends StatefulWidget {
  const AdminRouteList({Key? key}) : super(key: key);

  @override
  State<AdminRouteList> createState() => _AdminRouteListState();
}

class _AdminRouteListState extends State<AdminRouteList> {
  List<RouteM> myRoutes = [];
  late bool isLoading = true;
  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
  }

  @override
  void didChangeDependencies() {
    setState(() {
      isLoading = true;
    });
    Auth loginManager = Provider.of<Auth>(context, listen: false);
    DatabaseService myService =
        DatabaseService(uid: loginManager.getUser()!.uid);
    myService.getAdminRoutes().then((value) {
      setState(() {
        isLoading = false;
        myRoutes = value;
      });
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        color: Colors.transparent,
        child: const Center(
          child: SpinKitPouringHourGlass(
            color: Colors.black,
            size: 50.0,
          ),
        ),
      );
    }

    if (myRoutes.isEmpty) {
      return Text(AppLocalizations.of(context)!.createRouteFirst);
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        crossAxisCount: 2,
        children: [
          ...myRoutes
              .map((e) => RouteCard(
                  route: e,
                  isAdmin: true,
                  isFav: false,
                  onFavClick: () {},
                  remove: (RouteM removed) {
                    setState(() {
                      myRoutes.remove(removed);
                    });
                  },
                  update: () {
                    setState(() {});
                  }))
              .toList()
        ],
      ),
    );
  }
}
