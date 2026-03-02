import 'package:flutter/cupertino.dart';
import 'package:oneradar/pages/home_page.dart';
import 'package:oneradar/pages/onboarding_page.dart';


class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = false;

    // ignore: dead_code
    if (isLoggedIn) {
      return const HomePage();
    } else {
      return const OnboardingPage();
    }
  }
}