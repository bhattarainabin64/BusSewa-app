import 'package:flutter_geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetAddress {
  String? location;
  static getLocatioFromAddress(
      LatLng currentLocationUpdates, String userId) async {
    final coordinates = Coordinates(
        currentLocationUpdates.latitude, currentLocationUpdates.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);

    String location = addresses.first.subLocality.toString();
    return location;
  }
}
