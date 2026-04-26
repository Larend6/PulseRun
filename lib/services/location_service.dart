import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<String?> ensurePermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return 'GPS belum aktif. Aktifkan layanan lokasi di perangkat.';
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      return 'Izin lokasi ditolak. Aplikasi perlu GPS untuk tracking.';
    }

    if (permission == LocationPermission.deniedForever) {
      return 'Izin lokasi ditolak permanen. Buka pengaturan aplikasi.';
    }

    return null;
  }

  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 5,
      ),
    );
  }
}
