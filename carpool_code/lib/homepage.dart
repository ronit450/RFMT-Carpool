// ignore_for_file: unnecessary_this, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/drawer.dart';
import 'package:flutter_application_1/utils/routes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import 'package:flutter_application_1/widgets/drawer.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  @override
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          
            ),
        // this app bar creates  a header into our appp
        body: Stack(
          children: [
            SizedBox(
                height: size.height * 0.6,
                width: double.infinity,
                child: Image.asset(
                  "assets/images/map.png",
                  fit: BoxFit.cover,
                )),
            SizedBox(
              height: size.height * 0.2,
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
        drawer: MyDrawer());
  }
}
