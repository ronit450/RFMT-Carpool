// ignore_for_file: prefer_const_literals_to_create_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class ProgressDialogue extends StatelessWidget {
  

  String message ;
  ProgressDialogue({required this.message});


  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.purple,
      child: Container(
        margin: EdgeInsets.all(10.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0)
 
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(children: 
          [
            SizedBox(width: 3.0,),
            CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black),),
            SizedBox(width: 10),
            Text(message , style: TextStyle(color: Colors.purple,),)
          ],
          ),
        ),
      ),
      
    );
  }
}