import 'package:flutter_application_1/index.dart';

class Carpool_Request {
  String? area;
  String? time;
  String? date;

  Carpool_Request({this.area, this.time, this.date});

  factory Carpool_Request.fromMap(map) {
    return Carpool_Request(
      area: map['area'],
      time: map['time'],
      date: map['date'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'area': area,
      'time': time,
      'date': date,
    };
  }
}
