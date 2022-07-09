import 'package:flutter/material.dart';

class RideRequest extends StatefulWidget {
  const RideRequest({ Key? key }) : super(key: key);

  @override
  State<RideRequest> createState() => _RideRequestState();
}

class _RideRequestState extends State<RideRequest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            backgroundColor: Colors.white,
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
      body: Center(
                child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        height: 180,
                        child: Image.asset(
                          "assets/images/hu_logo.png",
                          fit: BoxFit.contain,
                        )),
          SizedBox(
            height: 20,
          ),
          Text(
          "Sorry, No Available Carpool Requests Found! We have added your request in our Database, We'll Let you Know If there are any requests.",
          style: TextStyle(color: Colors.purple, fontSize:24, fontWeight: FontWeight.bold),  
        )
                  ],
            )
          )
          )
      )
      ),
    );
  }
}