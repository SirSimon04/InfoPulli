import 'package:flutter/material.dart';
import 'package:info_pulli/screens/leaderboard/leaderboard.dart';
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Informatik LK"),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.map_rounded),
                text: "Karte",
              ),
              Tab(
                icon: Icon(Icons.account_circle),
                text: "Leaderboard",
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MainMap(
              position: widget.position,
            ),
            const LeaderBoard(),
          ],
        ),
      ),
    );
  }
}
