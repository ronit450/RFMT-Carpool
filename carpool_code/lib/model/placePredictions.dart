// ignore_for_file: non_constant_identifier_names

class placePredictions{
  late String secondary_text;
  late String main_text;
  late String place_id;

  // ignore: non_constant_identifier_names
  placePredictions({required this.secondary_text, required this.main_text, required this.place_id});

  placePredictions.fromJson(Map<String, dynamic> json){
    place_id = json["place_id"] ?? "";
    main_text = json["structured_formatting"]["main_text"] ?? "";
    secondary_text = json["secondary_text"] ?? "";
  }
}