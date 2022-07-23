// ignore_for_file: prefer_const_literals_to_create_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ProgressDialogue extends StatelessWidget {
  

  String message ;
  ProgressDialogue({required this.message});


  @override
  Widget build(BuildContext context) {
    return Dialog(
     backgroundColor: Colors.white,
     
 
        child: Padding(
             padding: const EdgeInsets.all(8.0),
          
          child: SizedBox(

    
            child: SizedBox(
              height: 110,
              child: Column(children: 
              [
                LoadingAnimationWidget.staggeredDotsWave(color: Colors.purple, size: 40),
                SizedBox(
                  height: 10,
                ),
               
                Text(message , style: TextStyle(color: Colors.purple,),)
              ],
              ),
            ),
          ),
        ),
   
      
    );
  }
}