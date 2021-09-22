import 'package:flutter/material.dart';
import 'package:info_pulli/screens/map/main_map.dart';
import 'package:location/location.dart';

class MapOrganizer extends StatefulWidget {
  LocationData? position;
  MapOrganizer({Key? key, this.position}) : super(key: key);

  @override
  _MapOrganizerState createState() => _MapOrganizerState();
}

class _MapOrganizerState extends State<MapOrganizer> {
  @override
  Widget build(BuildContext context) {
    return MainMap(
      position: widget.position,
    );
  }
}
