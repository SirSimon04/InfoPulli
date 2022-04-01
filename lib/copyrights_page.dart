import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class CopyrightsPage extends StatefulWidget {
  @override
  State<CopyrightsPage> createState() => _CopyrightsPageState();
}

class _CopyrightsPageState extends State<CopyrightsPage> {
  final String apiKey = "uHuXYU2hIlocJtD1UgIwV0O8omx8sZHv";

  String copyrightsText = "";

  Future<http.Response> getCopyrightsJSONResponse() async {
    String url = "https://api.tomtom.com/map/1/copyrights.json?key=$apiKey";
    var response = await http.get(Uri.parse(url));
    return response;
  }

  String parseCopyrightsResponse(http.Response response) {
    if (response.statusCode == 200) {
      StringBuffer stringBuffer = StringBuffer();
      var jsonResponse = convert.jsonDecode(response.body);
      parseGeneralCopyrights(jsonResponse, stringBuffer);
      parseRegionsCopyrights(jsonResponse, stringBuffer);
      return stringBuffer.toString();
    }
    return "Can't get copyrights";
  }

  void parseRegionsCopyrights(jsonResponse, StringBuffer sb) {
    List<dynamic> copyrightsRegions = jsonResponse["regions"];
    copyrightsRegions.forEach((element) {
      sb.writeln(element["country"]["label"]);
      List<dynamic> cpy = element["copyrights"];
      cpy.forEach((e) {
        sb.writeln(e);
      });
      sb.writeln("");
    });
  }

  void parseGeneralCopyrights(jsonResponse, StringBuffer sb) {
    List<dynamic> generalCopyrights = jsonResponse["generalCopyrights"];
    generalCopyrights.forEach((element) {
      sb.writeln(element);
      sb.writeln("");
    });
    sb.writeln("");
  }

  @override
  void initState() {
    super.initState();
    buildCR();
  }

  Future<void> buildCR() async {
    http.Response response = await getCopyrightsJSONResponse();
    setState(() {
      copyrightsText = parseCopyrightsResponse(response);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TomTom Maps API - Copyrights"),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Image.asset(
            "left-arrow.png",
            scale: 4,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.all(20), child: Text(copyrightsText)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
