import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

getCustomMarker(List<dynamic> pos) {
  return Marker(
    width: 80.0,
    height: 80.0,
    point: LatLng(pos[1], pos[2]),
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
              children: [
                Text(
                  pos[6] + " " + pos[7],
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Image(
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
              children: [
                Text("Hier wurde der Pulli von ${pos[6]} ${pos[7]} gescannt."),
                Text(DateTime.fromMillisecondsSinceEpoch(pos[0]).toString()),
                const Text("Grafenstraße 9")
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
  );
}
