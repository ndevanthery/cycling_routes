import 'package:cycling_routes/Models/trafficjam_m.dart';
import 'package:cycling_routes/Services/database.dart';
import 'package:cycling_routes/Shared/components/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AdminJamsPage extends StatefulWidget {
  const AdminJamsPage({super.key});

  @override
  State<AdminJamsPage> createState() => _AdminJamsPageState();
}

class _AdminJamsPageState extends State<AdminJamsPage> {
  List<TrafficJamM> myJams = [];
  bool isLoaded = false;
  DatabaseService mydbService = DatabaseService();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    DatabaseService serv = DatabaseService(uid: null);
    serv.getTrafficJams().then((value) {
      setState(() {
        myJams = value;
        isLoaded = true;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoaded == false) {
      return Loading();
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.toVerify,
            style: TextStyle(fontSize: 24),
          ),
          ..._getJamsToVerify(),
          SizedBox(
            height: 20,
          ),
          Text(
            AppLocalizations.of(context)!.displayed,
            style: TextStyle(fontSize: 24),
          ),
          ..._getJamsDisplayed(),
        ],
      ),
    );
  }

  _getJamsToVerify() {
    return myJams
        .where(((TrafficJamM element) => element.isValidated == false))
        .map(
          (e) => Slidable(
            endActionPane: ActionPane(motion: const DrawerMotion(), children: [
              SlidableAction(
                autoClose: true,
                flex: 1,
                onPressed: (value) {
                  setState(() {
                    mydbService.validateTrafficJam(e);
                    myJams.elementAt(myJams.indexOf(e)).isValidated = true;
                  });
                },
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                icon: Icons.done,
                label: AppLocalizations.of(context)!.correct,
              ),
              SlidableAction(
                autoClose: true,
                flex: 1,
                onPressed: (value) {
                  setState(() {
                    mydbService.deleteTrafficJam(e);
                    myJams.remove(e);
                  });
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.close,
                label: AppLocalizations.of(context)!.incorect,
              ),
            ]),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 0.50),
              ),
              child: ListTile(
                title: Text(DateFormat.yMMMMd(Get.locale!.languageCode)
                        .format(e.date!) +
                    "${AppLocalizations.of(context)!.at} ${e.date!.hour.toString().padLeft(2, '0')} ${e.date!.minute.toString().padLeft(2, '0')}"),
              ),
            ),
          ),
        )
        .toList();
  }

  _getJamsDisplayed() {
    return myJams
        .where(((TrafficJamM element) => element.isValidated == true))
        .map(
          (e) => Slidable(
            endActionPane: ActionPane(motion: const DrawerMotion(), children: [
              SlidableAction(
                autoClose: true,
                flex: 1,
                onPressed: (value) {
                  setState(() {
                    mydbService.deleteTrafficJam(e);
                    myJams.remove(e);
                  });
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: AppLocalizations.of(context)!.delete,
              ),
            ]),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 0.50),
              ),
              child: ListTile(
                title: Text(DateFormat.yMMMMd(Get.locale!.languageCode)
                        .format(e.date!) +
                    " ${AppLocalizations.of(context)!.at} ${e.date!.hour.toString().padLeft(2, '0')} ${e.date!.minute.toString().padLeft(2, '0')}"),
              ),
            ),
          ),
        )
        .toList();
  }
}
