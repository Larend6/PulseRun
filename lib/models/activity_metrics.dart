class ActivityMetrics {
  const ActivityMetrics({
    required this.duration,
    required this.distanceMeters,
    required this.currentSpeedKmh,
    required this.averageSpeedKmh,
    required this.steps,
    required this.motionStatus,
    required this.locationStatus,
    required this.isTracking,
    required this.isPaused,
    this.latitude,
    this.longitude,
    this.sensorSummary = 'Menunggu data sensor...',
  });

  final Duration duration;
  final double distanceMeters;
  final double currentSpeedKmh;
  final double averageSpeedKmh;
  final int steps;
  final String motionStatus;
  final String locationStatus;
  final bool isTracking;
  final bool isPaused;
  final double? latitude;
  final double? longitude;
  final String sensorSummary;

  factory ActivityMetrics.initial() {
    return const ActivityMetrics(
      duration: Duration.zero,
      distanceMeters: 0,
      currentSpeedKmh: 0,
      averageSpeedKmh: 0,
      steps: 0,
      motionStatus: 'Belum bergerak',
      locationStatus: 'Mencari GPS...',
      isTracking: false,
      isPaused: false,
    );
  }

  ActivityMetrics copyWith({
    Duration? duration,
    double? distanceMeters,
    double? currentSpeedKmh,
    double? averageSpeedKmh,
    int? steps,
    String? motionStatus,
    String? locationStatus,
    bool? isTracking,
    bool? isPaused,
    double? latitude,
    double? longitude,
    String? sensorSummary,
    bool clearLocation = false,
  }) {
    return ActivityMetrics(
      duration: duration ?? this.duration,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      currentSpeedKmh: currentSpeedKmh ?? this.currentSpeedKmh,
      averageSpeedKmh: averageSpeedKmh ?? this.averageSpeedKmh,
      steps: steps ?? this.steps,
      motionStatus: motionStatus ?? this.motionStatus,
      locationStatus: locationStatus ?? this.locationStatus,
      isTracking: isTracking ?? this.isTracking,
      isPaused: isPaused ?? this.isPaused,
      latitude: clearLocation ? null : latitude ?? this.latitude,
      longitude: clearLocation ? null : longitude ?? this.longitude,
      sensorSummary: sensorSummary ?? this.sensorSummary,
    );
  }
}
