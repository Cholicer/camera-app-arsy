import 'package:camera_app/core/errors/exceptions.dart';
import 'package:location/location.dart';

abstract class LocationLocalDataSource {
  Future<LocationData> getCurrentLocation();
}

class LocationLocalDataSourceImpl implements LocationLocalDataSource {
  final Location location;

  LocationLocalDataSourceImpl({required this.location});

  @override
  Future<LocationData> getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        throw LocationException();
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        throw LocationException();
      }
    }

    return await location.getLocation();
  }
}
