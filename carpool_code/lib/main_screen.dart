// ignore_for_file: prefer_final_fields, non_constant_identifier_names, unused_element, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/divider.dart';
import 'package:flutter_application_1/drawer.dart';
import 'package:flutter_application_1/model/user_model.dart';

import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/routes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Main_Screen extends StatefulWidget {
  const Main_Screen({Key? key}) : super(key: key);

  @override
  State<Main_Screen> createState() => _Main_ScreenState();
  
}

class _Main_ScreenState extends State<Main_Screen> {
  User? user = FirebaseAuth.instance.currentUser;
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
  String string_selected_date = "";
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  Completer<GoogleMapController> _google_map_controller = Completer();
  late GoogleMapController new_google_map_controller_for_saving;
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

// Carpool Request Button
    final makeRequest = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            // FirebaseFirestore.instance.collection("RideRequest").add(request_map);
            Navigator.pushNamed(context, Myroutes.Carpool_Request_page);
          },
          child: Text(
            "Request",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );


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
          ),
      
          ),
      drawer: MyDrawer(),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _google_map_controller.complete(controller);
              new_google_map_controller_for_saving = controller;
            },
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
              height: 350.0,
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
                        " Hi ${loggedInUser.firstName}",
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
                      pickup_and_dropoff("Search Pickup Location"),
                      SizedBox(
                        height: 10,
                      ),
                      pickup_and_dropoff("Search Dropoff Location"),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: size.height * 0.06,
                            width: size.width * 0.42,
                            child: InkWell(
                              child: TextFormField(
                                onSaved: (newValue) => selectedDate,
                                readOnly: true,
                                onTap: () {
                                  _selectDate(context);
                                  _dateController.clear();
                                },
                                textInputAction: TextInputAction.next,
                                focusNode: AlwaysDisabledFocusNode(),
                                controller: _dateController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.calendar_month),
                                  filled: true,
                                  hintText: "Date",
                                  contentPadding:
                                      EdgeInsets.fromLTRB(20, 15, 20, 15),
                                  labelText: "Date",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
 
              SizedBox(
              width: 5,
              ),
              SizedBox(
                height: size.height * 0.06,
                width: size.width * 0.42,
                child: InkWell(
                  child: TextFormField(
                    focusNode: AlwaysDisabledFocusNode(),
                    controller: _timeController,
                    readOnly: true,
                    onTap: () {
                      // FocusScope.of(context).requestFocus(FocusNode());
                      _selectTime(context);
                    },
                    autofocus: false,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.timer),
                      filled: true,
                      contentPadding:
                          EdgeInsets.fromLTRB(20, 15, 20, 15),
                      labelText: "Time",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),

                        ],
                      ),
            SizedBox(
              height: 10,
            ),
            makeRequest,

                      
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
