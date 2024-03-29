import 'package:flutter/material.dart';
import 'package:info_pulli/screens/map/main_map.dart';
import 'package:info_pulli/screens/map/map_organizer.dart';
import 'package:info_pulli/services/name_services.dart';
import 'package:info_pulli/services/networking.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScanInfoScreen extends StatefulWidget {
  final String scan;
  const ScanInfoScreen(this.scan, {Key? key}) : super(key: key);

  @override
  _ScanInfoScreenState createState() => _ScanInfoScreenState();
}

class _ScanInfoScreenState extends State<ScanInfoScreen> {
  String grantText = "Warte auf Erlaubnis...";
  bool isButtonDisabled = false;
  LocationData? position;
  bool isScanned = false;

  TextEditingController controller = TextEditingController();

  _lookupScan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> scans = await prefs.getStringList("scans") ?? [];
    if (scans.contains(widget.scan)) {
      setState(() {
        isScanned = true;
      });
      print("already scanned");
    } else {
      print("never scanned");
    }
  }

  _addScan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> scans = await prefs.getStringList("scans") ?? [];
    scans.add(widget.scan);
    prefs.setStringList("scans", scans);
  }

  @override
  void initState() {
    print(widget.scan);
    super.initState();
    _lookupScan();
  }

  @override
  Widget build(BuildContext context) {
    return isScanned
        ? Scaffold(
            backgroundColor: Colors.blueGrey[900],
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Center(
                      child: Text(
                        widget.scan == "buch"
                            ? "Du hast das Jahrbuch bereits gescannt"
                            : "Du hast den Pulli von ${NameService.getFullName(widget.scan)} bereits gescannt",
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            ?.copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Center(
                      child: Text(
                        widget.scan == "buch"
                            ? "Du kannst das Abibuch nur einmal scannen, deswegen kannst du leider keinen neune Scan senden"
                            : "Du kannst jeden Pulli nur einmal scannen, deswegen kannst du leider keinen neuen Scan senden",
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            ?.copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  TextButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.all(16.0)),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.blue.shade300),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: const BorderSide(
                                        color: Colors.blueGrey)))),
                    child: const Text(
                      "Hier gehts zur Karte",
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => MapOrganizer(
                                position: position,
                              )));
                    },
                  )
                ],
              ),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.black,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Center(
                      child: Text(
                        widget.scan == "buch"
                            ? "Du hast das Abibuch gescannt"
                            : "Du hast den Pulli von ${NameService.getFullName(widget.scan)} gescannt",
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            ?.copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Center(
                      child: Text(
                        "Wenn du möchtest, kannst du den Scan mit deinem Standort und einer Nachricht hinterlassen, die später auf der Karte angezeigt werden",
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            ?.copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: "Hinterlasse eine Nachricht...",
                        hintStyle:
                            TextStyle(color: Colors.grey.withOpacity(0.5)),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  TextButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.all(24.0)),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: const BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                    child: Text(
                      "Standort erlauben",
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                    ),
                    onPressed: isButtonDisabled
                        ? null
                        : () async {
                            setState(() {
                              isButtonDisabled = true;
                            });
                            Location location = Location();
                            PermissionStatus _permissionGranted;
                            _permissionGranted =
                                await location.requestPermission();
                            if (_permissionGranted !=
                                PermissionStatus.granted) {
                              await Network().addEmptyScan(widget.scan);

                              setState(() {
                                grantText =
                                    "Bei der Standortabfrage ist ein Fehler aufgetreten, dein Scan wurde ohne Standort gesendet";
                              });

                              await Network()
                                  .addScan(null, widget.scan, controller.text);

                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => MapOrganizer(),
                                ),
                              );
                            } else {
                              setState(() {
                                grantText = "Dein Scan wird verschickt (dauert bis zu 10s).";
                              });

                              LocationData pos = await location.getLocation();
                              position = pos;

                              print("pos of scan " + pos.longitude.toString());

                              await Network()
                                  .addScan(pos, widget.scan, controller.text);

                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => MapOrganizer(
                                    position: pos,
                                  ),
                                ),
                              );
                            }
                            _addScan();
                          },
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      grantText,
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          color: getGrantColor(), fontStyle: FontStyle.italic),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  TextButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.all(16.0)),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.blue.shade300),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: const BorderSide(
                                        color: Colors.blueGrey)))),
                    child: const Text(
                      "Hier gehts zur Karte",
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => MapOrganizer(
                                position: position,
                              )));
                    },
                  )
                ],
              ),
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
