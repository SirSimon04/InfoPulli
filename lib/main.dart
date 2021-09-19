import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import 'package:info_pulli/screens/map/main_map.dart';
import 'package:latlong2/latlong.dart';
import "package:http/http.dart" as http;
import "dart:convert" as convert;

void main() {
  String scan = Uri.base.queryParameters["scan"] ?? "nicht gefunden";
  print(scan);
  runApp(MyApp(scan));
}

class MyApp extends StatelessWidget {
  final String scan;

  const MyApp(this.scan);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Demo",
      theme: ThemeData.dark(),
      darkTheme: ThemeData.dark(),
      home: HomeScreen(scan),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String scan;

  const HomeScreen(this.scan);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    //final tomtomHQ = latLng.LatLng(52.376372, 4.908066);
    return MaterialApp(
      title: "Info-Pulli",
      home: MainMap(widget.scan),
    );
  }
}
