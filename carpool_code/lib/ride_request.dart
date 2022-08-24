// ignore_for_file: prefer_final_fields, non_constant_identifier_names, unused_element, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/dataHandler/dataHandler.dart';
import 'package:flutter_application_1/model/Request_Model.dart';
import 'package:flutter_application_1/model/user_model.dart';
import 'package:flutter_application_1/utils/routes.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ride_request extends StatefulWidget {
  const ride_request({Key? key}) : super(key: key);

  @override
  State<ride_request> createState() => _ride_requestState();
}

class _ride_requestState extends State<ride_request> {
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

  String string_selected_date = "";
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _pickup = TextEditingController();
  TextEditingController _dropoff = TextEditingController();

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
            postDetailsToFirestore();
            Navigator.pushNamed(context, Myroutes.Carpool_Request_page);
          },
          child: Text(
            "Request",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    Widget pickup_dropoff(String text, Icon icon_to_put,
        TextEditingController controller_for_field) {
      return Row(
        children: [
          Icon(icon_to_put.icon),
          SizedBox(
            width: 18,
          ),
          Expanded(
              child: Container(
              height: 45,

            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Padding(
              padding: EdgeInsets.all(3.0),
              child: TextField(
                controller: controller_for_field,
                decoration: InputDecoration(
                    hintText: "Pickup Location",
                    fillColor: Colors.grey,
                    filled: true,
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding:
                        EdgeInsets.only(left: 11, top: 8, bottom: 8)),
              ),
            ),
          ))
        ],
      );
    }

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
    // Widget select_date() {
    //     return InkWell(
    //       child: TextFormField(
    //         onSaved: (newValue) => selectedDate,
    //         readOnly: true,
    //         onTap: () {
    //           _selectDate(context);
    //           _dateController.clear();
    //         },
    //         textInputAction: TextInputAction.next,
    //         focusNode: AlwaysDisabledFocusNode(),
    //         controller: _dateController,
    //         decoration: InputDecoration(
    //                       fillColor: Colors.grey,
    //             border: InputBorder.none,
    //             isDense: true,
    //             contentPadding: EdgeInsets.only(left: 11, top: 8, bottom: 8),
    //           filled: true,
    //           hintText: "Date",
    //           labelText: "Date",
    //         ),
    //       ),
    //     );
    //   }

    Widget pickup_and_dropoff(String text) {
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
            ],
          ),
        ),
      );
    }

    // Select Date field for carpool request

    Size size = MediaQuery.of(context).size;
    String placeAddress =
        Provider.of<carpool_data>(context).pickupLocation!.placeName ?? "";
    _pickup.text = placeAddress;
    return Scaffold(
      body: Column(
        children: [
        Container(
          height: size.height,
          decoration: BoxDecoration(
            color: Colors.white,
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
              padding:
                  EdgeInsets.only(left: 25, right: 25, top: 25, bottom: 20),
              child: Column(
                children: [
                  SizedBox(height: 5),
                  Stack(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back)),
                      Center(
                        child: Text(
                          "Make a Request",
                          style:
                              TextStyle(fontSize: 25, fontFamily: "Brand-Bold"),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  pickup_dropoff("Search Pickup Location",
                      Icon(CupertinoIcons.location), _pickup),
                  SizedBox(
                    height: 18,
                  ),
                  pickup_dropoff("Search Dropoff Location",
                      Icon(Icons.pin_drop_outlined), _dropoff),
                  SizedBox(
                    height: 18,
                  ),
                  Row(
                    children: [
                      Icon(Icons.date_range),
                      SizedBox(
                        width: 18,),
                      Expanded(
                        child: Container(
                          height: 45,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(6),
                            ),
                         
                              child: Padding(
                                padding: EdgeInsets.all(3.0),
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
                                      fillColor: Colors.grey,
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.only(
                                          left: 11, top: 8, bottom: 8),
                                      filled: true,
                                      hintText: "Date",
                                      labelText: "Date",
                                    ),
                                  ),
                                ),
                              ),
                            
                            ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Icon(Icons.timer),
                      SizedBox(
                        width: 18,
                      ),
                      Expanded(
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
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
                                  fillColor: Colors.grey,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(
                                      left: 11, top: 8, bottom: 8),
                                  filled: true,
                                  labelText: "Time",

                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  makeRequest,
                ],
              )),
        )
      ]),
    );
  }

  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    Map<String, dynamic> data = {
      "pickup": GeoPoint(50, 90),
      "dropoff": GeoPoint(14, 60),
      "time": _timeController.text,
      "date": _dateController.text,
      "uid": user!.uid
    };

    Carpool_req reqModel = Carpool_req();

    // writing all the values
    reqModel.pickup = GeoPoint(40, 90);
    reqModel.dropoff = GeoPoint(40, 60);
    reqModel.date = "90";
    reqModel.time = "52";

    await firebaseFirestore.collection("carpool_req").doc(user!.uid).set(data);
    Fluttertoast.showToast(msg: "Request Added Sucessfully");
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
