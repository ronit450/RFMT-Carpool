// ignore_for_file: camel_case_types, unnecessary_import, unused_local_variable, unnecessary_null_comparison, curly_braces_in_flow_control_structures, unused_element, non_constant_identifier_names, await_only_futures, deprecated_member_use
// import 'dart:html';
import 'package:flutter_application_1/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/model/carpool_Request.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_application_1/drawer.dart';
import 'package:flutter_application_1/login_screen.dart';
import 'package:flutter_application_1/utils/routes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/model/locations.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Ride_Request extends StatefulWidget {
  const Ride_Request({Key? key}) : super(key: key);

  @override
  State<Ride_Request> createState() => _Ride_RequestState();
}

class _Ride_RequestState extends State<Ride_Request> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  final _auth = FirebaseAuth.instance;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String string_selected_date = "";
  // List <String> items = [] ;
  var items = <String>[];
  var retrievedData;
  var map = new Map();

 
  @override
  void initState() {
    super.initState();
    var collectionReferece = FirebaseFirestore.instance.collection('areas');
    collectionReferece.get().then((collectionSnapshot) {
      retrievedData = collectionSnapshot.docs.toList();
      items.clear();
      for (var i = 0; i < retrievedData.length - 1; i++) {
        items.add(retrievedData[i]['areaName']);
        map[retrievedData[i]['areaName']] = [
          retrievedData[i]['lat'],
          retrievedData[i]['long']
        ];
      }
      print(items);
    });
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  String dropdownvalue = 'Bahadurabad';

  // Defining the Text Controller for all the fields on page
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _areaController = TextEditingController();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked_s = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked_s != null)
      setState(() {
        selectedTime = picked_s;
        DateTime parsedTime =
            DateFormat.jm().parse(picked_s.format(context).toString());
        String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
        _timeController.text = formattedTime;
      });
  }

  Future<void> _selectarea(BuildContext context) async {
    final picked_area = await DropdownButtonHideUnderline(
      child: DropdownButton(
        iconEnabledColor: Colors.white,
        value: dropdownvalue,
        style: TextStyle(color: Colors.white),
        icon: Icon(Icons.keyboard_arrow_down),
        items: items.map((String items) {
          return DropdownMenuItem(
              value: items,
              child: Text(
                items,
                style: TextStyle(color: Colors.black),
              ));
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            dropdownvalue = newValue as String;
            _areaController.text = dropdownvalue;
          });
        },
      ),
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

  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = DateTime.now();
    Size size = MediaQuery.of(context).size;
    TimeOfDay selectedTime = TimeOfDay.now();
     var request_map = {loggedInUser.uid.toString(): [dropdownvalue, string_selected_date, selectedTime]};
    // Request
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

    return Scaffold(
      backgroundColor: Colors.white,
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
      // drawer: MyDrawer(),
      body: SingleChildScrollView(
          child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(36.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/images/hu_logo.png",
                  fit: BoxFit.contain,
                  height: 150,
                  
                ),

                SizedBox(
                  height: size.height * 0.04,
                ),

                SizedBox(
                  height: size.height * 0.06,
                  width: size.width * 0.7,
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
                        hintText: "Select Date",
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        labelText: "Select Date",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.04,
                ),

                SizedBox(
                  height: size.height * 0.06,
                  width: size.width * 0.7,
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
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        labelText: "Select Time",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: size.height * 0.04,
                ),

               
                SizedBox(
                  height: size.height * 0.06,
                  width: size.width * 0.7,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      filled: true,
                      prefixIcon: Icon(Icons.home_filled),
                      suffixIcon: Icon(Icons.arrow_downward),
                      contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                      hintText: "Select Area",
                      labelText: "Select Area",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: (DropdownButtonHideUnderline(
                        child: DropdownButton(
                          isExpanded: true,
                          iconEnabledColor: Colors.white,
                          value: dropdownvalue,
                          icon: Icon(Icons.keyboard_arrow_down),
                          items: items.map((String items) {
                            return DropdownMenuItem(
                                value: items,
                                child: Text(
                                  items,
                                  style: TextStyle(color: Colors.black),
                                ));
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              dropdownvalue = newValue as String;
                            });
                          },
                        ),
                      )),
                    ),
                  ),
                ),
                SizedBox(height: 35),
                makeRequest,
              ]),
        ),
      )),
    );
  }
  
}
class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
