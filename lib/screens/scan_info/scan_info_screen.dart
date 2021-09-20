import 'package:flutter/material.dart';
import 'package:info_pulli/screens/map/main_map.dart';
import 'package:info_pulli/services/name_services.dart';
import 'package:info_pulli/services/networking.dart';
import 'package:location/location.dart';

class ScanInfoScreen extends StatefulWidget {
  final String scan;
  ScanInfoScreen(this.scan);

  @override
  _ScanInfoScreenState createState() => _ScanInfoScreenState();
}

class _ScanInfoScreenState extends State<ScanInfoScreen> {
  String grantText = "Warte auf Erlaubnis...";
  bool isButtonDisabled = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Du hast den Pulli von ${NameService.getFullName(widget.scan)} gescannt",
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  ?.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 60,
          ),
          Center(
            child: Text(
              "Um deinen Scan zu verifizieren, ist deine Standorterlaubnis nötig",
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  ?.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          TextButton(
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(color: Colors.blue)))),
            child: Text(
              "Standort erlauben",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(color: Colors.white),
            ),
            onPressed: isButtonDisabled
                ? null
                : () async {
                    setState(() {
                      isButtonDisabled = true;
                    });
                    Location location = Location();
                    PermissionStatus _permissionGranted;
                    _permissionGranted = await location.requestPermission();
                    if (_permissionGranted != PermissionStatus.granted) {
                      await Network().addEmptyScan(widget.scan);

                      setState(() {
                        grantText =
                            "Bei der Standortabfrage ist ein Fehler aufgetreten, dein Scan wurde ihen Standort gesendet";
                      });
                      return;
                    } else {
                      setState(() {
                        grantText = "Dein Scan wird verschickt.";
                      });
                      LocationData position = await location.getLocation();
                      await Network().addScan(position, widget.scan);
                      setState(() {
                        grantText = "Dein Scan wurde verschickt!";
                      });
                    }
                  },
          ),
          const SizedBox(
            height: 50,
          ),
          Text(
            grantText,
            style: Theme.of(context)
                .textTheme
                .bodyText1
                ?.copyWith(color: getGrantColor(), fontStyle: FontStyle.italic),
          ),
          const SizedBox(
            height: 50,
          ),
          TextButton(
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.blue.shade300),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(color: Colors.blueGrey)))),
            child: const Text(
              "Hier gehts zur Karte",
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const MainMap()));
            },
          )
        ],
      ),
    );
  }

  getGrantColor() {
    if (grantText == "Warte auf Erlaubnis...") {
      return Colors.white;
    }
    if (grantText == "Es ist ein Fehler aufgetreten") {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }
}
