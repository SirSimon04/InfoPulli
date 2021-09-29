import 'package:info_pulli/services/name_services.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class Network {
  Network();

  Future addScan(LocationData? position, String short, String? text) async {
    final response = await http.post(
      Uri.parse("https://pulli.noskiller.de/add"),
      body: jsonEncode(
        <String, dynamic>{
          "latitude": position?.latitude,
          "longitude": position?.longitude,
          "accuracy": 1,
          "person_id": NameService.getId(short),
          "message": text ?? "Keine Nachricht hinterlassen",
        },
      ),
      //     headers: <String, String>{
      //   "Access-Control-Allow-Origin": "*",
      // },
    );
    print(response.statusCode);
    return response;
  }

  Future addEmptyScan(String short) async {
    final response = await http.post(
      Uri.parse("https://pulli.noskiller.de/add"),
      body: jsonEncode(
        <String, dynamic>{
          "latitude": null,
          "longitude": null,
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

  Future getCount() async {
    print("getCount");

    try {
      final response = await http.post(
        Uri.parse("https://pulli.noskiller.de/get_counts"),
        body: jsonEncode({}),
      );
      print("status " + response.statusCode.toString());
      List<dynamic> scans = jsonDecode(response.body)["content"];

      print("all scans " + scans.toString());
      print("scan " + scans[1].toString());
      print("anzahl " + scans[2]["count"].toString());
      return scans;
    } catch (e) {
      print(e);
    }
  }
}
