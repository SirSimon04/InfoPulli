import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import 'package:info_pulli/screens/map/main_map.dart';
import 'package:latlong2/latlong.dart';
import "package:http/http.dart" as http;
import "dart:convert" as convert;
import 'package:geolocator/geolocator.dart';

import 'copyrights_page.dart';

import 'package:uuid/uuid.dart';

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
  @override
  Widget build(BuildContext context) {
    //final tomtomHQ = latLng.LatLng(52.376372, 4.908066);
    return MaterialApp(
      title: "Info-Pulli",
      home: MainMap(),
    );
  }
}
