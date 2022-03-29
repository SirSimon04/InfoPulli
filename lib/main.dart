import "package:flutter/material.dart";
import 'package:info_pulli/screens/scan_info/scan_info_screen.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();
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
      theme: ThemeData.dark().copyWith(),
      darkTheme: ThemeData.dark().copyWith(),
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
      title: "Info LK 2022",
      home: ScanInfoScreen(widget.scan),
    );
  }
}
