import 'package:location/location.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class Network {
  Network();

  Future addScan(LocationData position) async {
    final response = await http.post(
      Uri.parse("http://home.noskiller.de/add"),
      body: jsonEncode(
        <String, double>{
          "latitude": position.latitude ?? 0,
          "longitude": position.longitude ?? 0,
          "accuracy": 1,
          "person_id": 3
        },
      ),
      //     headers: <String, String>{
      //   "Access-Control-Allow-Origin": "*",
      // },
    );
    print(response.statusCode);
    return response;
  }

  Future getAllLocations() async {
    print("getting locations");
    try {
      final response = await http.post(
          Uri.parse("https://home.noskiller.de/get_locations"),
          body: jsonEncode({}));
      List<dynamic> locations = jsonDecode(response.body)["content"];
      print(response.statusCode);
      print(locations);
      print(locations.first);
      return locations;
    } catch (e) {
      print(e);
    }
  }
}
