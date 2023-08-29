import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:info_pulli/services/name_services.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

final format = DateFormat("dd.MM.yyyy hh:mm");

getCustomMarker(List<dynamic> pos) {
  return Marker(
    width: 80.0,
    height: 80.0,
    point: LatLng(pos[1], pos[2]),
    builder: (BuildContext context) => IconButton(
      icon: Stack(
        children: [
          Image.asset(
            "assets/images/pin.png",
            scale: 2.8,
          ),
          Positioned(
            top: pos[5] == "buch" ? 8 : 0,
            left: pos[5] == "buch" ? 13 : 5,
            child: Center(
              child: Image(
                image: AssetImage(
                  NameService.getImagePath(pos[5]),
                ),
                height: pos[5] == "buch" ? 20 : 36,
                width: pos[5] == "buch" ? 20 : 36,
              ),
            ),
          ),
        ],
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: Colors.black,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  pos[6] + " " + pos[7],
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Image(
                  image: AssetImage(
                    NameService.getImagePath(pos[5]),
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
                //Text("Hier wurde der Pulli von ${pos[6]} ${pos[7]} gescannt."),
                Text(
                  format
                      .format(
                          DateTime.fromMillisecondsSinceEpoch(pos[0] * 1000))
                      .toString(),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  pos[8],
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  pos[9] ?? "Keine Nachricht",
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            // actions: [
            //   TextButton(
            //       child: const Text("Schließen"),
            //       onPressed: () {
            //         Navigator.of(context).pop();
            //       })
            // ],
          ),
        );
      },
    ),
  );
}

String getText(pos) {
  print("here  msg");
  try {
    print("msg " + pos[9]);
    return pos[9];
  } catch (e) {
    return "Keine Nachricht";
  }
}
