import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:tomato_record/router/locations.dart';
import 'package:tomato_record/screens/auth_screen.dart';
import 'package:tomato_record/screens/splash_screen.dart';
import 'package:tomato_record/utils/logger.dart';

final _routerDelegate = BeamerDelegate(guards: [
  BeamGuard(
      pathBlueprints: ['/'],
      check: (context, location) {
        return true;
      },
      showPage: BeamPage(child: AuthScreen()))
], locationBuilder: BeamerLocationBuilder(beamLocations: [HomeLocation()]));

void main() {
  logger.d('My first log by logger!!');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(Duration(seconds: 3), () => 100),
        builder: (context, snapshot) {
          return AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: _splashLoadingWidget(snapshot));
        });
  }

  StatelessWidget _splashLoadingWidget(AsyncSnapshot<Object?> snapshot) {
    if (snapshot.hasError) {
      print('error occur while loading.');
      return Text('Error occur');
    } else if (snapshot.hasData) {
      return TomatoApp();
    } else {
      return SplashScreen();
    }
  }
}

class TomatoApp extends StatelessWidget {
  const TomatoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: BeamerParser(),
      routerDelegate: _routerDelegate,
    );
  }
}
