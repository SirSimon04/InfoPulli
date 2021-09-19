import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Network {
  Network();

  Future addScan(Position position) async {
    final response = await http.post(
      Uri.parse("http://home.noskiller.de/add"),
      body: jsonEncode(
        <String, double>{
          "latitude": position.latitude,
          "longitude": position.longitude,
          "accuracy": position.accuracy,
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
}
