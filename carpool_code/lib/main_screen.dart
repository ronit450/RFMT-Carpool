// ignore_for_file: prefer_final_fields, non_constant_identifier_names

import 'dart:async';
import 'package:geolocator/geolocator.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/routes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Main_Screen extends StatefulWidget {
  const Main_Screen({ Key? key }) : super(key: key);

  @override
  State<Main_Screen> createState() => _Main_ScreenState();
}

class _Main_ScreenState extends State<Main_Screen> {



  Completer<GoogleMapController> _google_map_controller = Completer();
  late GoogleMapController new_google_map_controller_for_saving ;
      
  
    static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  @override
  Widget build(BuildContext context) {
  Size size = MediaQuery.of(context).size;
    return Scaffold(

            appBar: AppBar(
          backgroundColor: Colors.white,
          // elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.red),
            onPressed: () {
              // passing this to our root
              Navigator.of(context).pop();
            },
          )),
          body: Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                myLocationButtonEnabled: true,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller){
                  _google_map_controller.complete(controller);
                  new_google_map_controller_for_saving = controller;
                },
              ),

            Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: Container(
                height: 250.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 14.0,
                        offset: Offset(0.7,0.7),
                        spreadRadius: 0.5,
                      )
                    ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    SizedBox(height: 5.0),
                    Text("Hi Ronit,",
                      style: TextStyle(fontSize: 19),
                    ),
                    SizedBox(height: 26.0,),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.08,
                              width: size.width * 0.8,
                              child: ElevatedButton.icon(
                                icon: Icon(CupertinoIcons.location_circle),
                                label: Text(" Find Pool",
                                    style: TextStyle(
                                        fontFamily: GoogleFonts.abhayaLibre()
                                            .fontFamily,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold)),
                                style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    padding: EdgeInsets.all(10),
                                    backgroundColor: Colors.purple.shade400,
                                    shadowColor: Colors.yellow),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, Myroutes.ride_request);
                                },
                              ),
                            ),

                            // Making offer ride button
                            SizedBox(
                              height: size.height * 0.04,
                            ),
                            SizedBox(
                              height: size.height * 0.0,
                              width: size.width * 0.8,
                              child: ElevatedButton.icon(
                                icon: Icon(CupertinoIcons.car_detailed),
                                label: Text(" Offer Pool",
                                    style: TextStyle(
                                        fontFamily: GoogleFonts.abhayaLibre()
                                            .fontFamily,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold)),
                                style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    padding: EdgeInsets.all(10),
                                    backgroundColor: Colors.purple.shade400,
                                    shadowColor: Colors.yellow),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, Myroutes.ride_request);
                                },
                              ),
                            )
                          ],)
                  )
               
                  ]),
                ),
              ),
            ),
            ],
          ),
      
    );
  }
}