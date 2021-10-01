import 'package:flutter/material.dart';
import 'package:info_pulli/services/networking.dart';

class LeaderBoard extends StatefulWidget {
  const LeaderBoard({Key? key}) : super(key: key);

  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  List<String> names = [];
  List<int> scanCodes = [];
  List<String> shorts = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCounts();
  }

  Future<void> getCounts() async {
    var scans = await Network().getCount();
    List<String> n = [];
    List<String> s = [];
    List<int> sC = [];
    for (var person in scans) {
      n.add(person["first"] + person["last"]);
      s.add(person["short"]);
      sC.add(person["count"]);
    }

    setState(() {
      names = n;
      scanCodes = sC;
      shorts = s;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: names.isEmpty
          ? const CircularProgressIndicator()
          : SingleChildScrollView(
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
                    tileColor: getColor(index),
                    title: Text(names[index]),
                    leading: Image.asset("images/${shorts[index]}.png"),
                    trailing: Padding(
                      padding: const EdgeInsets.only(right: 32),
                      child: Text(scanCodes[index].toString()),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              ),
            ),
    );
  }

  Color getColor(int index) {
    if (index == 0) {
      return const Color(0xffAF9500);
    } else if (index == 1) {
      return const Color(0xffD7D7D7);
    } else if (index == 2) {
      return const Color(0xff6A3805);
    } else {
      return Colors.blueGrey;
    }
  }
}
