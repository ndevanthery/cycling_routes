// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AppAbout extends StatefulWidget {
  const AppAbout({Key? key}) : super(key: key);

  @override
  State<AppAbout> createState() => _AppAboutState();
}

class _AppAboutState extends State<AppAbout> {
// thisdetermnines whether the back-to-top button is shown or not
  bool _showBackToTopButton = false;

  // scroll controller
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          if (_scrollController.offset >= 400) {
            _showBackToTopButton = true; // show the back-to-top button
          } else {
            _showBackToTopButton = false; // hide the back-to-top button
          }
        });
      });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose(); // dispose the controller
    super.dispose();
  }

  // This function is triggered when the user presses the back-to-top button
  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[500],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    const Center(
                      child: Text(
                        'About RideOn',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    RichText(
                      textAlign: TextAlign.end,
                      text: const TextSpan(
                        text: 'Last Updated : 16-12-2022',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                'Powered by',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              RichText(
                textAlign: TextAlign.justify,
                text: const TextSpan(
                  text: 'The RideOn application hase been developped by ;',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              _buildPuce(mytext: 'Simon Beaud,'),
              _buildPuce(mytext: 'Sven Zengaffinen,'),
              _buildPuce(mytext: 'Nicolas Devanthéry'),
              _buildPuce(mytext: 'And Mégane Solliard'),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Purpose',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                ),
              ),
              RichText(
                textAlign: TextAlign.justify,
                text: const TextSpan(
                  text: ' ;',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Contact Us',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              RichText(
                textAlign: TextAlign.justify,
                text: const TextSpan(
                  text: "If you have any questions, You can contact us:",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              _buildPuce(mytext: 'rideon.hesso@gmail.com'),
              const SizedBox(
                height: 35,
              ),
              const Center(
                child: Text(
                  'Thank you',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _showBackToTopButton == false
          ? null
          : FloatingActionButton(
              elevation: 0.5,
              backgroundColor: Colors.grey[600],
              onPressed: _scrollToTop,
              child: const Icon(Icons.arrow_upward, color: Colors.black)),
    ));
  }

  Container _buildPuce({required String mytext}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 5, 5, 0),
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
          text: "",
          style: const TextStyle(
            color: Colors.black,
          ),
          children: [
            const TextSpan(
              text: "• ",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: mytext,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
