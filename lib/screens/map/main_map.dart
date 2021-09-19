// ignore_for_file: avoid_print

import "package:flutter/material.dart";
import 'package:flutter_map/flutter_map.dart';
import 'package:info_pulli/copyrights_page.dart';
import 'package:latlong2/latlong.dart';
import "package:info_pulli/services/location.dart";
import "package:info_pulli/services/networking.dart";
import 'package:location/location.dart';

class MainMap extends StatefulWidget {
  const MainMap({Key? key}) : super(key: key);

  @override
  _MainMapState createState() => _MainMapState();
}

class _MainMapState extends State<MainMap> {
  final String apiKey = "uHuXYU2hIlocJtD1UgIwV0O8omx8sZHv";

  String grantText = "";

  @override
  void initState() {
    super.initState();
    print("inifStae main map");
    // getPosAndSend();
  }

  void showPosDialog(context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text(
              "Du hast den Pulli von Lukas Bagniski gescannt",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
                "Um deinen Scan zu verifizieren, ist deine Standorterlaubnis nötig"),
            TextButton(
              child: const Text("Standort erlauben"),
              onPressed: () async {
                Location location = Location();
                PermissionStatus _permissionGranted;
                _permissionGranted = await location.requestPermission();
                if (_permissionGranted != PermissionStatus.granted) {
                  setState(() {
                    grantText = "Schade";
                  });
                } else {
                  setState(() {
                    grantText = "Schön";
                  });
                  LocationData position = await location.getLocation();
                  Network().addScan(position);
                  setState(() {
                    grantText = "Dein Scan wurde verschickt";
                  });
                }
              },
            ),
            Text(grantText),
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
  }

  // Future<void> getPosAndSend() async {
  //   try {
  //     LocationData pos = await LocationHelper().getPosition();
  //     print(pos);
  //     print(pos.accuracy);
  //     Network().addScan(pos);
  //     print("addedScan");
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () => showPosDialog(context));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Stack(
          children: <Widget>[
            FlutterMap(
              options: MapOptions(
                  center: LatLng(51.388514, 7.000371),
                  zoom: 13.0), //TODO: current pos
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
        child: const Icon(Icons.copyright),
        onPressed: () async {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CopyrightsPage()));
        },
      ),
    );
  }
}
