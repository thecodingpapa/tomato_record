import 'package:flutter/material.dart';
import 'package:tomato_record/screens/start/address_page.dart';
import 'package:tomato_record/screens/start/intro_page.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({Key? key}) : super(key: key);

  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            IntroPage(_pageController),
            AddressPage(),
            Container(
              color: Colors.accents[5],
            )
          ]),
    );
  }
}
