import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tomato_record/router/locations.dart';
import 'package:tomato_record/screens/start_screen.dart';
import 'package:tomato_record/screens/splash_screen.dart';
import 'package:tomato_record/states/user_provider.dart';
import 'package:tomato_record/utils/logger.dart';

final _routerDelegate = BeamerDelegate(guards: [
  BeamGuard(
      pathBlueprints: ['/'],
      check: (context, location) {
        return context.watch<UserProvider>().userState;
      },
      showPage: BeamPage(child: StartScreen()))
], locationBuilder: BeamerLocationBuilder(beamLocations: [HomeLocation()]));

void main() {
  logger.d('My first log by logger!!');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(Duration(milliseconds: 300), () => 100),
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
    return ChangeNotifierProvider<UserProvider>(
      create: (BuildContext context) {
        return UserProvider();
      },
      child: MaterialApp.router(
        theme: ThemeData(
            primarySwatch: Colors.red,
            fontFamily: 'DoHyeon',
            hintColor: Colors.grey[350],
            textTheme: TextTheme(
              button: TextStyle(color: Colors.white),
            ),
            textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    primary: Colors.white,
                    minimumSize: Size(48, 48))),
            appBarTheme: AppBarTheme(
                backgroundColor: Colors.white,
                elevation: 2,
                titleTextStyle: TextStyle(color: Colors.black87),
                actionsIconTheme: IconThemeData(color: Colors.black87))),
        routeInformationParser: BeamerParser(),
        routerDelegate: _routerDelegate,
      ),
    );
  }
}
