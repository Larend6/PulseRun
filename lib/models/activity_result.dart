import 'activity_metrics.dart';
import 'activity_type.dart';

class ActivityResult {
  const ActivityResult({
    required this.type,
    required this.metrics,
    required this.calories,
  });

  final ActivityType type;
  final ActivityMetrics metrics;
  final double calories;
}
