import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import 'package:latlong2/latlong.dart';
import "package:http/http.dart" as http;
import "dart:convert" as convert;
import 'package:geolocator/geolocator.dart';

import 'copyrights_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Demo",
      theme: ThemeData.dark(),
      darkTheme: ThemeData.dark(),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String apiKey = "uHuXYU2hIlocJtD1UgIwV0O8omx8sZHv";

  @override
  void initState() {
    super.initState();
    getPosition();
  }

  Future<void> getPosition() async {
    try {
      print("getting position");
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      print("sending");
      final response = await http.post(
        Uri.parse("http://home.noskiller.de/set"),
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
      //print(response);
      print(response.statusCode);
      print(jsonDecode(response.body));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    //final tomtomHQ = latLng.LatLng(52.376372, 4.908066);
    return MaterialApp(
      title: "Info-Pulli",
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Stack(
            children: <Widget>[
              FlutterMap(
                options:
                    MapOptions(center: LatLng(51.388514, 7.000371), zoom: 13.0),
                layers: [
                  TileLayerOptions(
                    urlTemplate: "https://api.tomtom.com/map/1/tile/basic/main/"
                        "{z}/{x}/{y}.png?key={apiKey}",
                    additionalOptions: {"apiKey": apiKey},
                  ),
                  MarkerLayerOptions(
                    markers: [
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: LatLng(51.388514, 7.000371),
                        builder: (BuildContext context) => IconButton(
                          icon: Stack(
                            children: const [
                              Icon(
                                Icons.location_on,
                                size: 60.0,
                                color: Colors.black,
                              ),
                              Positioned(
                                top: 0,
                                left: 12,
                                child: Center(
                                  child: Image(
                                    image: AssetImage(
                                      "assets/images/baginski.png",
                                    ),
                                    height: 36,
                                    width: 36,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Text(
                                      "Lukas Baginski",
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Image(
                                      image: AssetImage(
                                        "assets/images/baginski.png",
                                      ),
                                      width: 100,
                                      height: 100,
                                    ),
                                  ],
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                        "Hier wurde der Pulli von Lukas Baginski gescannt."),
                                    Text("27. 01. 2004"),
                                    Text("Grafenstraße 9")
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                      child: const Text("Schließen"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      })
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.copyright),
          onPressed: () async {
            http.Response response = await getCopyrightsJSONResponse();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CopyrightsPage(
                        copyrightsText: parseCopyrightsResponse(response))));
          },
        ),
      ),
    );
  }

  Future<http.Response> getCopyrightsJSONResponse() async {
    String url = "https://api.tomtom.com/map/1/copyrights.json?key=$apiKey";
    var response = await http.get(Uri.parse(url));
    return response;
  }

  String parseCopyrightsResponse(http.Response response) {
    if (response.statusCode == 200) {
      StringBuffer stringBuffer = StringBuffer();
      var jsonResponse = convert.jsonDecode(response.body);
      parseGeneralCopyrights(jsonResponse, stringBuffer);
      parseRegionsCopyrights(jsonResponse, stringBuffer);
      return stringBuffer.toString();
    }
    return "Can't get copyrights";
  }

  void parseRegionsCopyrights(jsonResponse, StringBuffer sb) {
    List<dynamic> copyrightsRegions = jsonResponse["regions"];
    copyrightsRegions.forEach((element) {
      sb.writeln(element["country"]["label"]);
      List<dynamic> cpy = element["copyrights"];
      cpy.forEach((e) {
        sb.writeln(e);
      });
      sb.writeln("");
    });
  }

  void parseGeneralCopyrights(jsonResponse, StringBuffer sb) {
    List<dynamic> generalCopyrights = jsonResponse["generalCopyrights"];
    generalCopyrights.forEach((element) {
      sb.writeln(element);
      sb.writeln("");
    });
    sb.writeln("");
  }
}
