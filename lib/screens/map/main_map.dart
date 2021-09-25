// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:html';

import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:info_pulli/copyrights_page.dart';
import 'package:info_pulli/services/name_services.dart';
import 'package:info_pulli/widgets/marker.dart';
import 'package:latlong2/latlong.dart';
import "package:info_pulli/services/location.dart";
import "package:info_pulli/services/networking.dart";
import 'package:location/location.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MainMap extends StatefulWidget {
  LocationData? position;
  MainMap({this.position});

  @override
  _MainMapState createState() => _MainMapState();
}

class _MainMapState extends State<MainMap> {
  final String apiKey = "uHuXYU2hIlocJtD1UgIwV0O8omx8sZHv";

  String grantText = "";

  List<Marker> customMarkerList = [];

  @override
  void initState() {
    super.initState();
    print("initState MainMap");
    getLocationsAndBuildMarkers();
  }

  Future<void> getLocationsAndBuildMarkers() async {
    print("getLocationsAndBuildMarkers");
    List<dynamic> positions = await Network().getAllLocations();
    List<Marker> newMarkerList = [];
    for (List<dynamic> pos in positions) {
      if (pos[1] != null) {
        newMarkerList.add(getCustomMarker(pos));
      }
    }
    setState(() {
      customMarkerList.addAll(newMarkerList);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("pos " + (widget.position?.longitude.toString() ?? " leer"));
    // Future.delayed(Duration.zero, () => showPosDialog(context));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Stack(
          children: <Widget>[
            FlutterMap(
              options: MapOptions(
                  center: LatLng(
                    widget.position?.latitude ?? 51.388514,
                    widget.position?.longitude ?? 7.000371,
                  ),
                  zoom: 13.0),
              layers: [
                TileLayerOptions(
                  urlTemplate: "https://api.tomtom.com/map/1/tile/basic/main/"
                      "{z}/{x}/{y}.png?key={apiKey}",
                  additionalOptions: {"apiKey": apiKey},
                ),
                MarkerLayerOptions(
                  markers: customMarkerList,
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

  // void showPosDialog(context) {
  //   showDialog(
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       title: Column(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           Text(
  //             "Du hast den Pulli von ${NameService.getFullName(widget.scan)} gescannt",
  //             style: const TextStyle(
  //               fontSize: 32,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ],
  //       ),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           const Text(
  //               "Um deinen Scan zu verifizieren, ist deine Standorterlaubnis nötig"),
  //           TextButton(
  //             child: const Text("Standort erlauben"),
  //             onPressed: () async {
  //               Location location = Location();
  //               PermissionStatus _permissionGranted;
  //               _permissionGranted = await location.requestPermission();
  //               if (_permissionGranted != PermissionStatus.granted) {
  //                 setState(() {
  //                   grantText = "Schade";
  //                 });
  //               } else {
  //                 setState(() {
  //                   grantText = "Dein Scan wurde verschickt.";
  //                 });
  //                 LocationData position = await location.getLocation();
  //                 Network().addScan(position, widget.scan);
  //                 setState(() {
  //                   grantText = "Dein Scan wurde verschickt";
  //                 });
  //               }
  //             },
  //           ),
  //           Text(grantText),
  //         ],
  //       ),
  //       actions: [
  //         TextButton(
  //             child: const Text("Schließen"),
  //             onPressed: () {
  //               Navigator.of(context).popUntil((route) => false);
  //             })
  //       ],
  //     ),
  //   );
  // }
}
