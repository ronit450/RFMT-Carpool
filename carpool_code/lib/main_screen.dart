// ignore_for_file: prefer_final_fields, non_constant_identifier_names, unused_element, prefer_const_literals_to_create_immutables, unnecessary_null_comparison

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/Reverse_Geocoding/place_searcher_methods.dart';
import 'package:flutter_application_1/bottomNavigation.dart';
import 'package:flutter_application_1/dataHandler/dataHandler.dart';
import 'package:flutter_application_1/divider.dart';
import 'package:flutter_application_1/drawer.dart';
import 'package:flutter_application_1/model/user_model.dart';
import 'package:flutter_application_1/model/Request_Model.dart';
import 'package:flutter_application_1/request_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/routes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class Main_Screen extends StatefulWidget {
  const Main_Screen({Key? key}) : super(key: key);

  @override
  State<Main_Screen> createState() => _Main_ScreenState();
  
}

class _Main_ScreenState extends State<Main_Screen> {
  User? user = FirebaseAuth.instance.currentUser;
  final _auth = FirebaseAuth.instance;
  UserModel loggedInUser = UserModel();
    void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  // Declaration of variables.
  double bottom_padding_of_map = 0.0 ;
  String string_selected_date = "";
  String home_temp = "Add Home";
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  Completer<GoogleMapController> _google_map_controller = Completer();
  late GoogleMapController new_google_map_controller_for_saving;

  late Position current_position;
  var geoLocater = Geolocator();




  void locateCurrentpos() async {
    
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    current_position = position;
    // As the location comes with Geopoint with lattitude and longitude
    LatLng lat_position = LatLng(position.latitude, position.longitude); 

    CameraPosition cameraPosition = new CameraPosition(target: lat_position, zoom:14);
    new_google_map_controller_for_saving.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address = await placeSearcherMethods.searchCoodinateAddress(position, context);
    print("ap yhan rehte hen?" + address);


  }


  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    // Select time field
    Future<void> _selectTime(BuildContext context) async {
      final TimeOfDay? picked_s = await showTimePicker(
        context: context,
        initialTime: selectedTime,
      );
      if (picked_s != null)
        // ignore: curly_braces_in_flow_control_structures
        setState(() {
          selectedTime = picked_s;
          DateTime parsedTime =
              DateFormat.jm().parse(picked_s.format(context).toString());
          String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
          _timeController.text = formattedTime;
        });
    }




    Widget pickup_and_dropoff(String text){
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 6.0,
              offset: Offset(0.7, 0.7),
              spreadRadius: 0.5,
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Icon(
                CupertinoIcons.search,
                color: Colors.purple,
              ),
              Text(text),
              SizedBox(
                height: 26.0,
              ),
              Divider_Widget(),
            ],
          ),
        ),


      );
    }

    // Select Date field for carpool request

    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime(2101));
      if (picked != null && picked != selectedDate) {
        setState(() {
          DateFormat dateFormat = DateFormat("yyyy-MM-dd");
          string_selected_date = dateFormat.format(selectedDate);
          var date =
              "${picked.toLocal().day}/${picked.toLocal().month}/${picked.toLocal().year}";
          selectedDate = picked;
          _dateController.text = date;
        });
      }
    }

    Widget home_and_work_row(String message1,  String message2, Icon icon_to_put){
      return Row(
            children: [
              Icon(icon_to_put.icon),
              SizedBox(width: 12.0,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(message1, style: TextStyle(fontSize: 10),),
                  SizedBox(height: 4,),
                  Text(message2,
                  style: TextStyle(color: Colors.black54),)
                ],
              )
            ],

      );
    }

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.red),
            onPressed: () {
              // passing this to our root
              Navigator.of(context).pop();
            },
          ),
      
          ),
      drawer: MyDrawer(),
    
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottom_padding_of_map),
            compassEnabled: true,
            mapType: MapType.normal,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex,

            // Map being created
            onMapCreated: (GoogleMapController controller) {
              _google_map_controller.complete(controller);
              new_google_map_controller_for_saving = controller;
              setState(() {
                bottom_padding_of_map = 300.0;
              });

              locateCurrentpos();
            },
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
              height: 320.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 14.0,
                    offset: Offset(0.7, 0.7),
                    spreadRadius: 0.5,
                  )
                ],
              ),
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5.0),
                      Text(
                        " Hi ${loggedInUser.firstName} ${loggedInUser.secondName}",
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        "Where to?",
                        style:
                            TextStyle(fontSize: 19, fontFamily: 'Brand-Bold'),
                      ),
                      SizedBox(
                        height: 26.0,
                      ),
// As this entire container is the search dropoff field so now we have to wrap it with gesturable 
                GestureDetector(
                  onTap: () {
                    // Now here we will make another page where user will be redirected. 
                  Navigator.pushNamed(context, Myroutes.ride_request);


                  },
                  child: Container(
                  decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 6.0,
                      offset: Offset(0.7, 0.7),
                      spreadRadius: 0.5,
                    )
                  ],
                              ),
                
                              child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(children: [
                    Icon(Icons.search, color: Colors.purple,),
                    SizedBox(width: 10,),
                    Text("Search Drop Off")
                  ]),
                              ),   
                          ),
                )
          ,
          SizedBox(height:26.0),
   
          home_and_work_row( (Provider.of<carpool_data>(context).pickupLocation != null

                          ? Provider.of<carpool_data>(context)
                              .pickupLocation
                              ?.placeName
                          : "Add home")!, "Your living address", Icon(Icons.home)),
          SizedBox(height: 10),
          Divider_Widget(),
          SizedBox(height: 20.0),
          home_and_work_row("Add University ", "Your University address", Icon(Icons.work)),
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}


class GeolocatorService {
  Future<Position?> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
    } else {
      throw Exception('Error');
    }
    return await Geolocator.getCurrentPosition();
  }
}
