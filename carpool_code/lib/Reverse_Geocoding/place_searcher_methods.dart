import 'dart:ffi';

import 'package:flutter_application_1/Reverse_Geocoding/place_searcher.dart';
import 'package:flutter_application_1/dataHandler/dataHandler.dart';
import 'package:flutter_application_1/model/address.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class placeSearcherMethods{
  // In this class we will code differnt methods tha will help us to play with reverse geocoding

  static Future<String> searchCoodinateAddress(Position position, context ) async {
    String placeAddress = "";
    String ad1, ad2, ad3, ad4;
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude}, ${position.longitude}&key=AIzaSyDp1X_HQ7CSm9Y0U6_VWPW7X7oT_jUcBos";
    
    var response = await placeSearcher.getRequest(url);
    if (response != "Failed!!"){
      ad1 = response["results"][0]["address_components"][1]["long_name"];
      ad2 = response["results"][0]["address_components"][2]["long_name"];
      ad3 = response["results"][0]["address_components"][3]["long_name"];


      placeAddress = ad1 + ", " +ad2+ ", " + ad3;

      Address userPickUpAddress = new Address();
      userPickUpAddress.lattitude = position.latitude;
      userPickUpAddress.longitude = position.longitude;

      userPickUpAddress.placeName = placeAddress;


      Provider.of<carpool_data>(context, listen: false).update_pickup_location_address(userPickUpAddress);

      

    }
    return placeAddress;
  }
}