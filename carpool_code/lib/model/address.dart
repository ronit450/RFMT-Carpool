

import 'package:cloud_firestore/cloud_firestore.dart';

class Address{
  String? placeFormattedAddress; 
  String? placeName;
  String? placeId;
  double? lattitude;
  double? longitude;

  Address({this.placeFormattedAddress, this.lattitude, this.longitude, this.placeId, this.placeName});
}
