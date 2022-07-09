// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/utils/routes.dart';

class Welcome extends StatelessWidget {
  const Welcome({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Material(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

          Image.asset("assets/images/welcome.png",
          fit: BoxFit.cover,
          height: size.height * 0.6,
          width: size.width* 0.8,),
          SizedBox(height: size.height * 0.05,
          ),
          
           Text(
                  "Welcome To Habib University Carpool Service",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26, color: Colors.purple.shade300),
                ),
          SizedBox(
            height: size.height * 0.05,
          ),
           SizedBox(
             height: size.height * 0.07,
             width: size.width * 0.4,
             child: ElevatedButton(
    
               style: TextButton.styleFrom(
                 backgroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 10),
                            shadowColor: Colors.purple,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    child: Text("Login"),
            
                    onPressed: () {
                      Navigator.pushNamed(context, Myroutes.login);
                    },
                  ),
           ),
           SizedBox(
            height: size.height * 0.01,
           ),
           SizedBox(
                  height: size.height*0.07,
                  width: size.width * 0.4,
                  child: ElevatedButton(
                    
                    style: TextButton.styleFrom(
                       backgroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    child: Text("Signup"),
                   
                    onPressed: () {
                      Navigator.pushNamed(context, Myroutes.signup);
                    },
                  ),
                ),
          Image.asset("assets/images/login.png",
          fit: BoxFit.cover,
          height: size.height*0.4,
          width: size.width* 0.6,),
          SizedBox(height: 30,
          ), 


          
        ]),
    )
    );
  }
}