import 'dart:developer';

import 'package:cycling_routes/Shared/components/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:provider/provider.dart';

import '../../Models/user_m.dart';
import '../../Services/auth.dart';
import '../../Shared/components/user_data_form.dart';
import '../../Shared/constants.dart';

class AccountSettings extends StatefulWidget {
  AccountSettings({Key? key}) : super(key: key);

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  late bool isLoading;

  //Fields State
  late String error;

  @override
  initState() {
    error = '';
    isLoading = false;
    super.initState();
  }

  @override
  void dispose() {
    error = '';
    super.dispose();
  }

  updateError(String err) {
    setState(() {
      error = err;
    });
    log('New Error Set : $error');
  }

  updateLoading(bool isLoad) {
    setState(() {
      isLoading = isLoad;
    });
    log('is loading : $isLoading');
  }

  @override
  Widget build(BuildContext context) {
    Auth loginManager = Provider.of<Auth>(context, listen: true);

    return isLoading
        ? const Loading()
        : SafeArea(
            child: Scaffold(
            appBar: AppBar(
              title: const Text('Account Details'),
              backgroundColor: Colors.grey[500],
            ),
            backgroundColor: Colors.white,
            body: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: CustomScrollView(
                scrollDirection: Axis.vertical,
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(10.0, 40, 10.0, 20),
                          child: Column(
                            children: [
                              const Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Change all your personnal information',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    'You must enter your current password to be able to make changes.',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey[700]),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    'If you enter a new password, this one will be immediatly effetive ! ',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey[700]),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                              color: Color.fromRGBO(224, 224, 224, 1),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25))),
                          margin: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 30),
                          child: UserDataForm(
                            isRegisterForm: false,
                            user: loginManager.getUser(),
                            error: error,
                            updateError: updateError,
                            isLoading: isLoading,
                            updateLoading: updateLoading,
                            termsAccepted: true,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ));
  }
}
