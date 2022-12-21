import 'dart:developer';

import 'package:cycling_routes/Models/route_m.dart';
import 'package:cycling_routes/Services/database.dart';
import 'package:cycling_routes/Shared/components/route_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../Models/user_m.dart';
import '../../Services/auth.dart';

class RouteCard extends StatefulWidget {
  RouteM route;
  bool isAdmin;
  bool isFav;
  Function onFavClick;
  Function? remove;
  Function? update;
  RouteCard(
      {Key? key,
      required this.route,
      required this.isAdmin,
      required this.isFav,
      required this.onFavClick,
      this.remove,
      this.update})
      : super(key: key);
  @override
  State<RouteCard> createState() => _RouteCardState();
}

class _RouteCardState extends State<RouteCard> {
  UserM? user;

  @override
  void didChangeDependencies() {
    user = Provider.of<UserM?>(context);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Auth loginManager = Provider.of<Auth>(context, listen: false);
    DatabaseService dbManager =
        DatabaseService(uid: loginManager.getUser()!.uid);

    return Container(
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RouteDetails(
                  route: widget.route,
                  isAdmin: widget.isAdmin,
                ),
              )).then((value) {
            if (widget.update != null) {
              widget.update!();
            }
          });
        },
        onLongPress: widget.isAdmin
            ? () {
                _dialDeleteRoute();
              }
            : null,
        child: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: const Image(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/velo_tour.jpg"),
                  width: 170,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: widget.isAdmin
                        ? Container()
                        : GestureDetector(
                            onTap: () {
                              dbManager.manageFavs(
                                  widget.route, loginManager.getUser()!);
                              widget.onFavClick();
                              widget.isFav = !widget.isFav;
                              setState(() {});
                            },
                            child: Icon(
                              widget.isFav
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_outline_rounded,
                              size: 15,
                            ),
                          ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${widget.route.name}",
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                        Text(
                          "Dist: ${widget.route.distance}${AppLocalizations.of(context)!.time}${widget.route.duration}${AppLocalizations.of(context)!.sec}",
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _dialDeleteRoute() {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.delete),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(AppLocalizations.of(context)!.deleteSure),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          contentPadding: const EdgeInsets.fromLTRB(24, 15, 24, 15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          actions: <Widget>[
            TextButton(
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: const TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                AppLocalizations.of(context)!.delete2,
                style: const TextStyle(color: Colors.black),
              ),
              onPressed: () async {
                DatabaseService serv = DatabaseService(uid: null);
                await serv.deleteRoute(widget.route);
                widget.remove!(widget.route);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
