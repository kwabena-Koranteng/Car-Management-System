import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:provider/provider.dart';
import './AppProvider.dart';
import 'package:car_rental/showroom.dart';
import 'available_cars.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApps());
}

class MyApps extends StatefulWidget {
  @override
  _MyAppsState createState() => new _MyAppsState();
}

class _MyAppsState extends State<MyApps> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: SplashScreen(
      title: new Text(
        'Car Rental App',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
      ),
      seconds: 5,
      navigateAfterSeconds: MyApp(),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: new TextStyle(),
      loaderColor: Colors.black,
    ));
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AppProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.muliTextTheme(),
        ),
        debugShowCheckedModeBanner: false,
        home: AvailableCars(),
      ),
    );
  }
}
