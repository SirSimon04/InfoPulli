import 'package:geolocator/geolocator.dart';

class Location {
  Future<Position> getPosition() async {
    try {
      print("getting position");
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      print("sending");
      return position;
      //print(response);
    } catch (e) {
      print(e);
      throw Exception("Could not get Position");
    }
  }
}
