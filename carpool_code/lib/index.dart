// ignore_for_file: use_key_in_widget_constructors, unused_field, unused_local_variable

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/dataHandler/dataHandler.dart';
import 'package:flutter_application_1/homepage.dart';

import 'package:flutter_application_1/login_screen.dart';
import 'package:flutter_application_1/main_screen.dart';
import 'package:flutter_application_1/model/carpool_Request.dart';
import 'package:flutter_application_1/registration_screen.dart';
import 'package:flutter_application_1/request_page.dart';
import 'package:flutter_application_1/ride_request.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_application_1/welcome.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Carpool());
}

class Carpool extends StatelessWidget {
  // const Carpool({Key? key}) : super(key: key);
  // final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // This is done because we want to add some data which can be accessible with all the pages we will access. 
      // This have changed the functionality to change notifier provider
      create: (context) => carpool_data(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        debugShowMaterialGrid: false,
        // defining the routes of program
        // the initial route will be of login page
        title: 'HU CARPOOL',
        theme: ThemeData(
            primarySwatch: Colors.purple,
            appBarTheme: AppBarTheme(
                backgroundColor: Colors.white,
                // elevation is the the line between the bar and the entire home page
                elevation: 0.0,
                iconTheme: IconThemeData(color: Colors.purple))),
        // home: const Login_Page(title: 'Flutter Demo Home Page'),
        // home: FutureBuilder(
        //   future: _initialization,
        //   builder: (context, snapshot){
        //     if (snapshot.hasError){
        //       print("Error");
        //     }
        //     if (snapshot.connectionState == ConnectionState.done){
        //       return LoginScreen();
        //     }
        //     return CircularProgressIndicator();
        //   },
        // ),
        initialRoute: '/main_screen',
        routes: {
          '/': (context) => Welcome(),
          '/login': (context) => LoginScreen(),
          '/home': (context) => Homepage(),
          '/signup': (context) => RegistrationScreen(),
          '/ride_request': (context) => ride_request(),
          '/request_page' :(context) => RideRequest(),
          '/main_screen':(context) => Main_Screen(),
        },
      ),
    );
  }
}
