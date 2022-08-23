import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/model/address.dart';


class carpool_data extends ChangeNotifier
{

  Address? pickupLocation;


  void update_pickup_location_address(Address pickup){
    pickupLocation = pickup;
    // notify will update the user about any change. 
    notifyListeners();
  }

}