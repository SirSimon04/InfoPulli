import 'package:info_pulli/services/name_services.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class Network {
  Network();

  Future addScan(LocationData position, String short) async {
    final response = await http.post(
      Uri.parse("https://pulli.noskiller.de/add"),
      body: jsonEncode(
        <String, dynamic>{
          "latitude": position.latitude ?? 0,
          "longitude": position.longitude ?? 0,
          "accuracy": 1,
          "person_id": NameService.getId(short),
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
          Uri.parse("https://pulli.noskiller.de/get_locations"),
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
