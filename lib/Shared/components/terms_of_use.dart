// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class TermOfUse extends StatefulWidget {
  const TermOfUse({Key? key}) : super(key: key);

  @override
  State<TermOfUse> createState() => _TermOfUseState();
}

class _TermOfUseState extends State<TermOfUse> {
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
        backgroundColor: Colors.grey[800],
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop('User Disagreed');
              },
              child: const Text('DISAGREE',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold))),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop('User Agreed');
              },
              child: const Text('AGREE',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold))),
        ],
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
                        'Terms & Conditions',
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
                        text: 'Last Updated : 01-12-2022',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        text:
                            'Please read these terms and conditions carefully before using Our Service.',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                'Interpretation and Definitions',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Interpretation',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              RichText(
                textAlign: TextAlign.justify,
                text: const TextSpan(
                  text:
                      'The words of which the initial letter is capitalized have meanings defined under the following conditions. The following definitions shall have the same meaning regardless of whether they appear in singular or in plural.',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Definitions',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'For the purposes of these Terms and Conditions:',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: const TextSpan(
                    text: "",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: "Application ",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text:
                            'means the software program provided by the Company downloaded by You on any electronic device, named RideOn',
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: const TextSpan(
                    text: "",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: "Application Store ",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                          text:
                              "means the digital distribution service operated and developed by Google Inc. (Google Play Store) in which the Application has been downloaded."),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: const TextSpan(
                    text: "",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: "Affiliate ",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                          text:
                              """means an entity that controls, is controlled by or is under common control with a party, where "control" means ownership of 50% or more of the shares, equity interest or other securities entitled to vote for election of directors or other managing authority."""),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: const TextSpan(
                    text: "",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: "Country ",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(text: 'refers to: Switzerland')
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: const TextSpan(
                    text: "",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: "Company ",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                          text:
                              '(referred to as either "the Company", "We", "Us" or "Our" in this Agreement) refers to RideOn.')
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: const TextSpan(
                    text: "",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: "Device ",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                          text:
                              'means any device that can access the Service such as a computer, a cellphone or a digital tablet.')
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: const TextSpan(
                    text: "",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: "Service ",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(text: 'refers to the Application.')
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: const TextSpan(
                    text: "",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: "Terms and Conditions ",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                          text:
                              '(also referred as "Terms") mean these Terms and Conditions that form the entire agreement between You and the Company regarding the use of the Service. This Terms and Conditions agreement has been created with the help of the Free Terms and Conditions Generator.')
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: const TextSpan(
                    text: "",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: "Third-party Social Media Service ",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                          text:
                              'means any services or content (including data, information, products or services) provided by a third-party that may be displayed, included or made available by the Service.')
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: const TextSpan(
                    text: "",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: "You   ",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                          text:
                              'means the individual accessing or using the Service, or the company, or other legal entity on behalf of which such individual is accessing or using the Service, as applicable.')
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Acknowledgment',
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
                  text:
                      "These are the Terms and Conditions governing the use of this Service and the agreement that operates between You and the Company. These Terms and Conditions set out the rights and obligations of all users regarding the use of the Service.",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              RichText(
                textAlign: TextAlign.justify,
                text: const TextSpan(
                  text:
                      "Your access to and use of the Service is conditioned on Your acceptance of and compliance with these Terms and Conditions. These Terms and Conditions apply to all visitors, users and others who access or use the Service.",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              RichText(
                textAlign: TextAlign.justify,
                text: const TextSpan(
                  text:
                      "By accessing or using the Service You agree to be bound by these Terms and Conditions. If You disagree with any part of these Terms and Conditions then You may not access the Service.",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              RichText(
                textAlign: TextAlign.justify,
                text: const TextSpan(
                  text:
                      "All personal data collected on the application will not be shared to anyone external to the company except you.",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Links to Other Websites',
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
                  text:
                      "Our Service may contain links to third-party web sites or services that are not owned or controlled by the Company.",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              RichText(
                textAlign: TextAlign.justify,
                text: const TextSpan(
                  text:
                      "The Company has no control over, and assumes no responsibility for, the content, privacy policies, or practices of any third party web sites or services. You further acknowledge and agree that the Company shall not be responsible or liable, directly or indirectly, for any damage or loss caused or alleged to be caused by or in connection with the use of or reliance on any such content, goods or services available on or through any such web sites or services.",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              RichText(
                textAlign: TextAlign.justify,
                text: const TextSpan(
                  text:
                      "We strongly advise You to read the terms and conditions and privacy policies of any third-party web sites or services that You visit.",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Termination',
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
                  text:
                      "We may terminate or suspend Your access immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach these Terms and Conditions.",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              RichText(
                textAlign: TextAlign.justify,
                text: const TextSpan(
                  text:
                      "Upon termination, Your right to use the Service will cease immediately.",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Governing Law',
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
                  text:
                      "The laws of the Country, excluding its conflicts of law rules, shall govern this Terms and Your use of the Service. Your use of the Application may also be subject to other local, state, national, or international laws.",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Disputes Resolution',
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
                  text:
                      "If You have any concern or dispute about the Service, You agree to first try to resolve the dispute informally by contacting the Company.",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'For European Union (EU) Users',
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
                  text:
                      "If You are a European Union consumer, you will benefit from any mandatory provisions of the law of the country in which you are resident in.",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'United States Legal Compliance',
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
                  text:
                      """You represent and warrant that (i) You are not located in a country that is subject to the United States government embargo, or that has been designated by the United States government as a "terrorist supporting" country, and (ii) You are not listed on any United States government list of prohibited or restricted parties.""",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Severability and Waiver',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Severability',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              RichText(
                textAlign: TextAlign.justify,
                text: const TextSpan(
                  text:
                      "If any provision of these Terms is held to be unenforceable or invalid, such provision will be changed and interpreted to accomplish the objectives of such provision to the greatest extent possible under applicable law and the remaining provisions will continue in full force and effect.",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Waiver',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              RichText(
                textAlign: TextAlign.justify,
                text: const TextSpan(
                  text:
                      "Except as provided herein, the failure to exercise a right or to require performance of an obligation under these Terms shall not effect a party's ability to exercise such right or require such performance at any time thereafter nor shall the waiver of a breach constitute a waiver of any subsequent breach.",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Translation Interpretation',
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
                  text:
                      "These Terms and Conditions may have been translated if We have made them available to You on our Service. You agree that the original English text shall prevail in the case of a dispute.",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Changes to These Terms and Conditions',
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
                  text:
                      "We reserve the right, at Our sole discretion, to modify or replace these Terms at any time. If a revision is material We will make reasonable efforts to provide at least 30 days' notice prior to any new terms taking effect. What constitutes a material change will be determined at Our sole discretion.",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              RichText(
                textAlign: TextAlign.justify,
                text: const TextSpan(
                  text:
                      "By continuing to access or use Our Service after those revisions become effective, You agree to be bound by the revised terms. If You do not agree to the new terms, in whole or in part, please stop using the website and the Service.",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
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
                  text:
                      "If you have any questions about these Terms and Conditions, You can contact us:",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 5, 0),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: const TextSpan(
                    text: "",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: "• ",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(text: "By email:  "),
                      TextSpan(
                        text: "rideon.hesso@gmail.com",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
}
