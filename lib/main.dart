import 'package:beamer/beamer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tomato_record/router/locations.dart';
import 'package:tomato_record/screens/start_screen.dart';
import 'package:tomato_record/screens/splash_screen.dart';
import 'package:tomato_record/states/user_notifier.dart';
import 'package:tomato_record/utils/logger.dart';

final _routerDelegate = BeamerDelegate(
    guards: [
      BeamGuard(
          pathBlueprints: [
            ...HomeLocation().pathBlueprints,
            ...InputLocation().pathBlueprints,
            ...ItemLocation().pathBlueprints
          ],
          check: (context, location) {
            return context.watch<UserNotifier>().user != null;
          },
          showPage: BeamPage(child: StartScreen()))
    ],
    locationBuilder: BeamerLocationBuilder(
        beamLocations: [HomeLocation(), InputLocation(), ItemLocation()]));

void main() {
  logger.d('My first log by logger!!');
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
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
    } else if (snapshot.connectionState == ConnectionState.done) {
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
    return ChangeNotifierProvider<UserNotifier>(
      create: (BuildContext context) {
        return UserNotifier();
      },
      child: MaterialApp.router(
        theme: ThemeData(
            primarySwatch: Colors.red,
            fontFamily: 'DoHyeon',
            hintColor: Colors.grey[350],
            textTheme: TextTheme(
              button: TextStyle(color: Colors.white),
              subtitle1: TextStyle(color: Colors.black87, fontSize: 15),
              subtitle2: TextStyle(color: Colors.grey, fontSize: 13),
              bodyText1: TextStyle(
                  color: Colors.black87,
                  fontSize: 12,
                  fontWeight: FontWeight.normal),
              bodyText2: TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                  fontWeight: FontWeight.w100),
            ),
            textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    primary: Colors.white,
                    minimumSize: Size(48, 48))),
            appBarTheme: AppBarTheme(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                elevation: 2,
                titleTextStyle: TextStyle(color: Colors.black87),
                actionsIconTheme: IconThemeData(color: Colors.black87)),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
                selectedItemColor: Colors.black87,
                unselectedItemColor: Colors.black54)),
        routeInformationParser: BeamerParser(),
        routerDelegate: _routerDelegate,
      ),
    );
  }
}
