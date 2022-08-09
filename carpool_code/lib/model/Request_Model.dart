import 'package:cloud_firestore/cloud_firestore.dart';

class Carpool_req {
  String? rid;
  GeoPoint? pickup;
  GeoPoint? dropoff;
  String? date;
  String? time;

  Carpool_req({this.rid, this.pickup, this.dropoff, this.date, this.time});

  // receiving data from server
  factory Carpool_req.fromMap(map) {
    return Carpool_req(
      rid: map['rid'],
      pickup: map['pickup'],
      dropoff: map['dropoff'],
      date: map['date'],
      time: map['time'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'rid': rid,
      'pickup': pickup,
      'dropoff': dropoff,
      'date': date,
      'time' : time,
    };
  }
}
