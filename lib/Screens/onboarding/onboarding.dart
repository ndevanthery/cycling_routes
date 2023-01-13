import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/onboarding_content.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Onboarding extends StatefulWidget {
  final Function setFirstLaunch;
  const Onboarding({Key? key, required this.setFirstLaunch}) : super(key: key);

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  late PageController _pageController;

  int currentIndex = 0;

  @override
  void initState() {
    setState(() {
      currentIndex = 0;
    });
    _pageController = PageController(initialPage: currentIndex);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  storeOnboardInfo() async {
    log("Shared pref called");
    int isViewed = 0;
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt('onBoard', isViewed);
    widget.setFirstLaunch(isViewed);
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> contents = [
      {
        "txt": AppLocalizations.of(context)!.firstOnboardTxt,
        "img": 'assets/img/Destination.png',
      },
      {
        "txt": AppLocalizations.of(context)!.secndOnboardTxt,
        "img": 'assets/img/bike_ride.png',
      },
      {
        "txt": AppLocalizations.of(context)!.thirdOnboardTxt,
        "img": 'assets/img/Posts.png',
      }
    ];

    return Scaffold(
      body: SafeArea(
        child: Container(
            color: Colors.white,
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  Expanded(
                      flex: 3,
                      child: PageView.builder(
                          itemCount: contents.length,
                          controller: _pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          onPageChanged: (int index) {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                          itemBuilder: (context, index) => OnboardingContent(
                                txt: contents[index]["txt"]!,
                                img: contents[index]["img"]!,
                              ))),
                  Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          children: [
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(contents.length,
                                  (index) => buildDot(index: index)),
                            ),
                            const Spacer(
                              flex: 1,
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      backgroundColor: Colors.amber),
                                  onPressed: () async {
                                    if (currentIndex == contents.length - 1) {
                                      await storeOnboardInfo();
                                    }

                                    _pageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.bounceIn,
                                    );
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.btnOnboardTxt,
                                    style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  )),
                            ),
                            TextButton(
                                onPressed: () async {
                                  await storeOnboardInfo();
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.skipTxt,
                                  style: const TextStyle(color: Colors.grey),
                                )),
                            const Spacer()
                          ],
                        ),
                      ))
                ],
              ),
            )),
      ),
    );
  }

  GestureDetector buildDot({required int index}) {
    return GestureDetector(
      onTap: (() {
        log('index : $index tapped');
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.bounceIn,
        );
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 5),
        height: 10,
        width: currentIndex == index ? 30 : 10,
        decoration: BoxDecoration(
            color: currentIndex == index ? Colors.amber : Colors.grey,
            borderRadius: BorderRadius.circular(5)),
      ),
    );
  }
}
