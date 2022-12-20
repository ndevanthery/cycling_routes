// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:cycling_routes/Models/route_m.dart';
import 'package:cycling_routes/Services/database.dart';
import 'package:cycling_routes/Shared/components/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../Services/auth.dart';
import '../../Shared/components/route_card.dart';

//##############################
//TODO : manage the onpress method for filter only favs (btn on top)
//TODO : make the reload of the page "automatically"
//when we click on the heart of 1 card it changes in db -> its OK
//But whe have to reload to see the changes maybe change how we get routes to a stream ? idk

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<RouteM> allRoutes = [];
  late bool isLoading = true;
  late bool showOnlyFavs = false;
  String sortBy = "name";
  bool isAscending = true;

  @override
  void initState() {
    super.initState();
    isLoading = true;
  }

  @override
  void didChangeDependencies() {
    setState(() {
      isLoading = true;
    });
    Auth loginManager = Provider.of<Auth>(context, listen: false);
    DatabaseService myService =
        DatabaseService(uid: loginManager.getUser()!.uid);

    // Get all routes
    myService.getRoutes(loginManager.getUser()!).then((value) => setState(() {
          isLoading = false;
          allRoutes = value;
          allRoutes.sort(((a, b) {
            return a.name!.compareTo(b.name!);
          }));
        }));

    super.didChangeDependencies();
  }

  _resetList(List<RouteM> newRoutes) {
    setState(() {
      allRoutes = newRoutes;
    });
  }

  toggleShowFavs() {
    setState(() {
      showOnlyFavs = !showOnlyFavs;
    });
    //TODO  make the list update
    // runShowOnlyFavs(showOnlyFavs, _resetList);
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

    if (allRoutes.isEmpty) {
      return Text("No routes here for now ! ");
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          width: double.infinity,
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 1,
                child: IconButton(
                  padding: EdgeInsets.fromLTRB(2, 2, 4, 0),
                  icon: showOnlyFavs
                      ? Icon(Icons.favorite_rounded)
                      : Icon(Icons.favorite_outline_rounded),
                  color: Colors.grey[700],
                  hoverColor: Colors.black,
                  onPressed: () => toggleShowFavs(),
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  padding: EdgeInsets.fromLTRB(2, 2, 4, 0),
                  icon: Icon(Icons.sort),
                  color: Colors.grey[700],
                  hoverColor: Colors.black,
                  onPressed: () {
                    _dialSort().then((value) => setState((() {})));
                  },
                ),
              ),
            ],
          ),
        ),
        // SizedBox(
        //   height: 10,
        // ),
        Expanded(
          flex: 5,
          child: GridView.count(
            crossAxisCount: 2,
            children: <Widget>[
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
          ),
        ),
      ],
    );
  }

//Filter
  void runFilter(String inputText, Function resetList) {
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

    resetList(results);
  }

  void runShowOnlyFavs(bool showFavs, Function resetList) {
    List<RouteM> results = [];

    if (!showFavs) {
      results = _SearchPageState().allRoutes;
    } else {
      results = _SearchPageState()
          .allRoutes
          .where((Routes) => Routes.isFav == true)
          .toList();
    }

    resetList(results);
  }

  Future<void> _dialSort() async {
    String tempSortBy = sortBy;
    bool tempIsAscending = isAscending;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text("Sort Routes"),
            content: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: ListBody(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            tempSortBy = "name";
                          });
                        },
                        child: Text("Name"),
                        style: ElevatedButton.styleFrom(
                            primary: tempSortBy == "name" ? Colors.red : null),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            tempSortBy = "distance";
                          });
                        },
                        child: Text("distance"),
                        style: ElevatedButton.styleFrom(
                            primary:
                                tempSortBy == "distance" ? Colors.red : null),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            tempSortBy = "time";
                          });
                        },
                        child: Text("Time"),
                        style: ElevatedButton.styleFrom(
                            primary: tempSortBy == "time" ? Colors.red : null),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            tempIsAscending = true;
                          });
                        },
                        child: Text("Ascending"),
                        style: ElevatedButton.styleFrom(
                            primary: tempIsAscending ? Colors.red : null),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            tempIsAscending = false;
                          });
                        },
                        child: Text("Descending"),
                        style: ElevatedButton.styleFrom(
                            primary: !tempIsAscending ? Colors.red : null),
                      ),
                    ],
                  )
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
                  "cancel",
                  style: const TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  "Ok",
                  style: const TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  setState(() {
                    switch (tempSortBy) {
                      case "name":
                        if (tempIsAscending) {
                          allRoutes.sort(((a, b) {
                            return a.name!.compareTo(b.name!);
                          }));
                        } else {
                          allRoutes.sort(((a, b) {
                            return b.name!.compareTo(a.name!);
                          }));
                        }
                        break;
                      case "distance":
                        if (tempIsAscending) {
                          allRoutes.sort(((a, b) {
                            return a.distance!.compareTo(b.distance!);
                          }));
                        } else {
                          allRoutes.sort(((a, b) {
                            return b.distance!.compareTo(a.distance!);
                          }));
                        }
                        break;
                      case "time":
                        if (tempIsAscending) {
                          allRoutes.sort(((a, b) {
                            return a.duration!.compareTo(b.duration!);
                          }));
                        } else {
                          allRoutes.sort(((a, b) {
                            return b.duration!.compareTo(a.duration!);
                          }));
                        }
                        break;
                    }
                  });
                  sortBy = tempSortBy;
                  isAscending = tempIsAscending;
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }
}
