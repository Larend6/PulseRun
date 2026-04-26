import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart' hide ActivityType;

import '../models/activity_metrics.dart';
import '../models/activity_result.dart';
import '../models/activity_type.dart';
import 'location_service.dart';
import 'sensor_service.dart';

class ActivityTrackingService extends ChangeNotifier {
  ActivityTrackingService({
    required this.activityType,
    LocationService? locationService,
    SensorService? sensorService,
  }) : _locationService = locationService ?? LocationService(),
       _sensorService = sensorService ?? SensorService();

  final ActivityType activityType;
  final LocationService _locationService;
  final SensorService _sensorService;

  ActivityMetrics _metrics = ActivityMetrics.initial();
  ActivityMetrics get metrics => _metrics;

  StreamSubscription<Position>? _positionSubscription;
  Timer? _timer;
  Position? _lastPosition;

  Future<void> start() async {
    _metrics = ActivityMetrics.initial().copyWith(
      isTracking: true,
      motionStatus: 'Menyiapkan sensor...',
      locationStatus: 'Memeriksa izin lokasi...',
    );
    notifyListeners();

    final permissionError = await _locationService.ensurePermission();
    if (permissionError != null) {
      _metrics = _metrics.copyWith(
        isTracking: false,
        motionStatus: 'Tracking belum dimulai',
        locationStatus: permissionError,
      );
      notifyListeners();
      return;
    }

    _sensorService.reset();
    _sensorService.start(_handleSensorSnapshot);
    _positionSubscription = _locationService.getPositionStream().listen(
      _handlePositionUpdate,
      onError: (Object _) {
        _metrics = _metrics.copyWith(
          locationStatus: 'Terjadi masalah saat membaca GPS.',
        );
        notifyListeners();
      },
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_metrics.isPaused || !_metrics.isTracking) {
        return;
      }

      final nextDuration = _metrics.duration + const Duration(seconds: 1);
      _metrics = _metrics.copyWith(
        duration: nextDuration,
        averageSpeedKmh: _calculateAverageSpeed(
          _metrics.distanceMeters,
          nextDuration,
        ),
      );
      notifyListeners();
    });

    _metrics = _metrics.copyWith(
      motionStatus: 'Tracking aktif',
      locationStatus: 'GPS aktif, menunggu perpindahan...',
    );
    notifyListeners();
  }

  void pause() {
    _sensorService.setCountingEnabled(false);
    _lastPosition = null;
    _metrics = _metrics.copyWith(
      isPaused: true,
      motionStatus: 'Aktivitas dijeda',
    );
    notifyListeners();
  }

  void resume() {
    _sensorService.setCountingEnabled(true);
    _lastPosition = null;
    _metrics = _metrics.copyWith(
      isPaused: false,
      motionStatus: 'Tracking dilanjutkan',
    );
    notifyListeners();
  }

  Future<ActivityResult> finish() async {
    final finalMetrics = _metrics.copyWith(
      isTracking: false,
      isPaused: false,
      averageSpeedKmh: _calculateAverageSpeed(
        _metrics.distanceMeters,
        _metrics.duration,
      ),
    );

    _metrics = finalMetrics;
    await _disposeTrackingResources();
    notifyListeners();

    return ActivityResult(
      type: activityType,
      metrics: finalMetrics,
      calories: _calculateCalories(finalMetrics),
    );
  }

  @override
  void dispose() {
    unawaited(_disposeTrackingResources());
    super.dispose();
  }

  Future<void> _disposeTrackingResources() async {
    _timer?.cancel();
    _timer = null;
    await _positionSubscription?.cancel();
    _positionSubscription = null;
    await _sensorService.stop();
  }

  void _handleSensorSnapshot(SensorSnapshot snapshot) {
    if (_metrics.isPaused || !_metrics.isTracking) {
      return;
    }

    _metrics = _metrics.copyWith(
      steps: snapshot.steps,
      motionStatus: snapshot.movementLabel,
      sensorSummary: snapshot.summary,
    );
    notifyListeners();
  }

  void _handlePositionUpdate(Position position) {
    if (_metrics.isPaused || !_metrics.isTracking) {
      return;
    }

    double distanceMeters = _metrics.distanceMeters;
    if (_lastPosition != null) {
      // Jarak ditotal dari perpindahan antar titik GPS.
      distanceMeters += Geolocator.distanceBetween(
        _lastPosition!.latitude,
        _lastPosition!.longitude,
        position.latitude,
        position.longitude,
      );
    }
    _lastPosition = position;

    final speedKmh =
        position.speed.isFinite && position.speed >= 0
            ? position.speed * 3.6
            : 0.0;

    _metrics = _metrics.copyWith(
      distanceMeters: distanceMeters,
      currentSpeedKmh: speedKmh,
      averageSpeedKmh: _calculateAverageSpeed(distanceMeters, _metrics.duration),
      latitude: position.latitude,
      longitude: position.longitude,
      locationStatus: 'Lokasi aktif dan terus diperbarui',
    );
    notifyListeners();
  }

  double _calculateAverageSpeed(double distanceMeters, Duration duration) {
    final hours = duration.inSeconds / 3600;
    if (hours <= 0) {
      return 0;
    }

    return (distanceMeters / 1000) / hours;
  }

  double _calculateCalories(ActivityMetrics metrics) {
    const bodyWeightKg = 60.0;
    final hours = metrics.duration.inSeconds / 3600;
    return activityType.metValue * bodyWeightKg * hours;
  }
}
