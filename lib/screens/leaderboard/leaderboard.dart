import 'package:flutter/material.dart';
import 'package:info_pulli/services/networking.dart';

class LeaderBoard extends StatefulWidget {
  const LeaderBoard({Key? key}) : super(key: key);

  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  final List<String> names = <String>[
    "Simon Engel",
    "Lukas Krinke",
    "Lukas Baginski",
    "Simon Engel",
    "Lukas Krinke",
    "Lukas Baginski",
    "Simon Engel",
    "Lukas Krinke",
    "Lukas Baginski",
    "Simon Engel",
    "Lukas Krinke",
    "Lukas Baginski",
  ];
  final List<int> scanCodes = <int>[
    100,
    5,
    4,
    100,
    5,
    4,
    100,
    5,
    4,
    100,
    5,
    4,
  ];
  final List<String> shorts = <String>[
    "engel",
    "krinke",
    "baginski",
    "engel",
    "krinke",
    "baginski",
    "engel",
    "krinke",
    "baginski",
    "engel",
    "krinke",
    "baginski",
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Network().getCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: SingleChildScrollView(
        child: ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          itemCount: names.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              contentPadding: const EdgeInsets.all(8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              tileColor: Colors.blueGrey[100],
              title: Text(names[index]),
              leading: Image.asset("images/${shorts[index]}.png"),
              trailing: Text(scanCodes[index].toString()),
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        ),
      ),
    );
  }
}
