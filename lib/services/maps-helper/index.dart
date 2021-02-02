import 'package:codered/utils/constants/keys.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:http/http.dart' as http;

class CodeRedMapsHelper {
  void obtainPlaceDirectionDetails(LatLng initialpos, LatLng finalpos) async {
    String apiURL =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${initialpos.latitude},${initialpos.longitude}&destination=${finalpos.latitude},$finalpos.longitude}&key=${CodeRedKeys.mapsAPIKey}";

    var response = await http.get(apiURL);

    // Failed
    if (response.statusCode != 200) {
      return;
    }
  }
}
