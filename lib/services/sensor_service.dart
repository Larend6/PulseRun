import 'dart:async';
import 'dart:math';

import 'package:sensors_plus/sensors_plus.dart';

class SensorSnapshot {
  const SensorSnapshot({
    required this.steps,
    required this.movementLabel,
    required this.summary,
    required this.accelerationMagnitude,
    required this.rotationMagnitude,
  });

  final int steps;
  final String movementLabel;
  final String summary;
  final double accelerationMagnitude;
  final double rotationMagnitude;
}

class SensorService {
  StreamSubscription<UserAccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;

  int _steps = 0;
  bool _stepReady = true;
  DateTime _lastStepTime = DateTime.fromMillisecondsSinceEpoch(0);
  double _latestAccelerationMagnitude = 0;
  double _latestRotationMagnitude = 0;
  bool _isCountingEnabled = true;
  void Function(SensorSnapshot snapshot)? _onUpdate;

  void start(void Function(SensorSnapshot snapshot) onUpdate) {
    _onUpdate = onUpdate;
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();

    _accelerometerSubscription = userAccelerometerEventStream(
      samplingPeriod: SensorInterval.gameInterval,
    ).listen(_handleAccelerometerData);

    _gyroscopeSubscription = gyroscopeEventStream(
      samplingPeriod: SensorInterval.gameInterval,
    ).listen(_handleGyroscopeData);
  }

  void reset() {
    _steps = 0;
    _stepReady = true;
    _latestAccelerationMagnitude = 0;
    _latestRotationMagnitude = 0;
    _lastStepTime = DateTime.fromMillisecondsSinceEpoch(0);
    _isCountingEnabled = true;
  }

  void setCountingEnabled(bool isEnabled) {
    _isCountingEnabled = isEnabled;
  }

  Future<void> stop() async {
    await _accelerometerSubscription?.cancel();
    await _gyroscopeSubscription?.cancel();
    _accelerometerSubscription = null;
    _gyroscopeSubscription = null;
  }

  void _handleAccelerometerData(UserAccelerometerEvent event) {
    final magnitude = sqrt(
      (event.x * event.x) + (event.y * event.y) + (event.z * event.z),
    );
    _latestAccelerationMagnitude = magnitude;

    final now = DateTime.now();
    // Step counter sederhana berbasis puncak percepatan.
    if (_isCountingEnabled && magnitude > 1.35 && _stepReady) {
      final timeSinceLastStep = now.difference(_lastStepTime).inMilliseconds;
      if (timeSinceLastStep > 280) {
        _steps += 1;
        _lastStepTime = now;
        _stepReady = false;
      }
    }

    if (magnitude < 0.55) {
      _stepReady = true;
    }

    _emitSnapshot();
  }

  void _handleGyroscopeData(GyroscopeEvent event) {
    _latestRotationMagnitude = sqrt(
      (event.x * event.x) + (event.y * event.y) + (event.z * event.z),
    );
    _emitSnapshot();
  }

  void _emitSnapshot() {
    final movementLabel = _resolveMovementLabel();
    final summary =
        'Accel ${_latestAccelerationMagnitude.toStringAsFixed(2)} m/s²'
        ' • Gyro ${_latestRotationMagnitude.toStringAsFixed(2)} rad/s';

    _onUpdate?.call(
      SensorSnapshot(
        steps: _steps,
        movementLabel: movementLabel,
        summary: summary,
        accelerationMagnitude: _latestAccelerationMagnitude,
        rotationMagnitude: _latestRotationMagnitude,
      ),
    );
  }

  String _resolveMovementLabel() {
    if (_latestAccelerationMagnitude < 0.35 && _latestRotationMagnitude < 0.08) {
      return 'Diam';
    }

    if (_latestAccelerationMagnitude < 0.9 && _latestRotationMagnitude < 0.3) {
      return 'Gerakan ringan';
    }

    if (_latestAccelerationMagnitude < 1.7 && _latestRotationMagnitude < 0.9) {
      return 'Berjalan/Jogging stabil';
    }

    return 'Gerakan aktif';
  }
}
