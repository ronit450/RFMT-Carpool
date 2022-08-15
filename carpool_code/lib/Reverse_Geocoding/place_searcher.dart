import 'dart:convert';


import 'package:http/http.dart' as http;

class placeSearcher{
  static Future<dynamic> getRequest(String url) async{
    http.Response response  = await http.get(Uri.parse(url));
    // We are using try as it is better if we encounter any error then it must not stop the application. 
    try{
          if(response.statusCode == 200)
    // 200 response is sucessfull
    {
      String jSonData = response.body;
      var jSonData_decoded = jsonDecode(jSonData);
      return jSonData_decoded;
    }
    else{
      return "Failed!!";
    }
    }
    catch(exp)
    {
      return "Failed!!";
    }


  }
}