// ignore_for_file: prefer_final_fields, non_constant_identifier_names, unused_element, prefer_const_literals_to_create_immutables, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Reverse_Geocoding/place_searcher.dart';
import 'package:flutter_application_1/dataHandler/dataHandler.dart';
import 'package:flutter_application_1/divider.dart';
import 'package:flutter_application_1/main_screen.dart';
import 'package:flutter_application_1/model/Request_Model.dart';
import 'package:flutter_application_1/model/google_maps.dart';
import 'package:flutter_application_1/model/placePredictions.dart';
import 'package:flutter_application_1/model/placePredictions.dart';
import 'package:flutter_application_1/model/user_model.dart';
import 'package:flutter_application_1/utils/routes.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'model/placePredictions.dart';



class ride_request extends StatefulWidget {
  final Position current_pos; 
  const ride_request(this.current_pos, {Key? key}) : super(key: key);

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
  List<placePredictions> placePredictions_lst = [];


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
    Widget makeRequest(String text_to_add){
    return Material(
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
            text_to_add,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );
    }

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
                onChanged: (val){
                  find_location(val, widget.current_pos);
                },
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
          height: size.height*0.8,
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
                                          left: 15, top: 15, bottom: 15),
                                      filled: true,
                                      hintText: "Date",
                                      
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
                                      left: 15, top: 15, bottom: 15),
                                  filled: true,
                                  hintText: "Time",

                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  makeRequest("Request Carpool"),
                  SizedBox(height: 40,),
                  makeRequest("Post Carpool"),
                ],
              )),
        ),
      // tile for predictions to be added as list
       
        (placePredictions_lst.length>0)? Padding(padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16), child: ListView.separated(
          padding: EdgeInsets.all(0),
          itemBuilder: (context, index){
            return PredictionTile(placePredictions_obj: placePredictions_lst[index],);

          },
          separatorBuilder: (BuildContext context, int index) => Divider_Widget(),
          itemCount:placePredictions_lst.length,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
        ),):Container(),
      ]),
    );
  }
  void find_location(String placeName, Position current_pos) async{
   if(placeName !=  null){
    final main_screen_obj = Main_Screen();
      final current_lat = current_pos.latitude;
      final current_lon = current_pos.latitude;
  

      
      String auto_complete_url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$google_map_api_key&components=country:pk&radius=100000&location=$current_lat%$current_lon";

      var response = await placeSearcher.getRequest(auto_complete_url);

      if (response =="failed"){
        return;
      }

      print(response);

      if (response["status"] == "OK"){
        var predictions = response["predictions"];
        // this will basically convery the json data in list format
        var place_lst = (predictions as List).map((e) => placePredictions.fromJson(e)).toList();
        placePredictions_lst = place_lst;
        
        setState(() {
          placePredictions_lst = place_lst;
        });

      }

   }
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




class PredictionTile extends StatelessWidget {
  final placePredictions placePredictions_obj;
  const PredictionTile({ Key? key, required this.placePredictions_obj }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 10 ,
          ),
          Row(children: [
          Icon(Icons.add_location),
          SizedBox(width: 14.0,), 
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(placePredictions_obj.main_text, overflow: TextOverflow.ellipsis, style:  TextStyle(fontSize: 16),),
                SizedBox(height: 3,),
                Text(placePredictions_obj.secondary_text, overflow: TextOverflow.ellipsis,
                  style:  TextStyle(fontSize: 12, color: Colors.grey),
                ),
          
              ],
            ),
          )
        ]),
        SizedBox(
          height: 10,
        )

        ],
      ),
      
    );
  }
}