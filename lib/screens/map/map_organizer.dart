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
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Image.asset(
                  "assets/images/map.png",
                  color: Colors.white,
                  scale: 2,
                ),
                text: "Karte",
              ),
              Tab(
                icon: Image.asset(
                  "assets/images/user_icon.png",
                  color: Colors.white,
                  scale: 2,
                ),
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
