import 'package:flutter_application_1/Reverse_Geocoding/place_searcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class placeSearcherMethods{
  // In this class we will code differnt methods tha will help us to play with reverse geocoding

  static Future<String> searchCoodinateAddress(Position position) async {
    String placeAddress = "";
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude}, ${position.longitude}&key=AIzaSyDp1X_HQ7CSm9Y0U6_VWPW7X7oT_jUcBos";
    
    var response = await placeSearcher.getRequest(url);
    if (response != "Failed!!"){
      placeAddress = response["results"][0]["formatted_address"];


    }
    return placeAddress;
  }
}