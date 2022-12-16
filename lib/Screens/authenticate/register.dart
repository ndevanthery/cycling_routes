import 'dart:developer';

import 'package:cycling_routes/Shared/components/terms_of_use_text.dart';
import 'package:cycling_routes/routes_generator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Services/auth.dart';
import '../../Shared/components/loading.dart';
import '../../Shared/components/powered_by.dart';
import '../../Shared/components/user_data_form.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late bool isLoading;
  late bool termAccepted;

  //Fields State
  late String error;

  @override
  initState() {
    super.initState();
    error = '';
    isLoading = false;
    termAccepted = true;
  }

  @override
  void dispose() {
    error = '';
    isLoading = false;
    termAccepted = true;
    super.dispose();
  }

  toggleTerms(bool isAccepted) {
    setState(() {
      termAccepted = isAccepted;
    });
    log('Update agreement to $termAccepted');
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
        : Stack(children: <Widget>[
            Image.asset(
              "assets/img/bkg_signin.jpg",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    RoutesGenerator.sailor.pop();
                  },
                  icon: Image.asset(
                    "assets/icons/back_white.png",
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                actions: [
                  SizedBox(
                    width: 140,
                    height: 70.0,
                    child: Image.asset(
                      "assets/img/logo_removebg.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
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
                          Container(
                            margin: const EdgeInsets.fromLTRB(10, 25, 10, 3),
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: const Text(
                              "Let's join the ride !",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                    color: Color.fromRGBO(224, 224, 224, 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25))),
                                margin: const EdgeInsets.fromLTRB(15, 0, 10, 8),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 30),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    UserDataForm(
                                      user: loginManager.getUser(),
                                      error: error,
                                      updateError: updateError,
                                      isLoading: isLoading,
                                      updateLoading: updateLoading,
                                      termsAccepted: termAccepted,
                                    ),
                                    TermOfUseText(
                                        toggleTerms: toggleTerms,
                                        isAccepted: termAccepted),
                                  ],
                                ),
                              ),
                              const PoweredBy(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]);
  }
}
