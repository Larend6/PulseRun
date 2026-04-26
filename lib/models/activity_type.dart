import 'package:flutter/material.dart';

enum ActivityType { walking, jogging, lightRunning }

extension ActivityTypeX on ActivityType {
  String get label {
    switch (this) {
      case ActivityType.walking:
        return 'Jalan Kaki';
      case ActivityType.jogging:
        return 'Jogging';
      case ActivityType.lightRunning:
        return 'Lari Ringan';
    }
  }

  String get description {
    switch (this) {
      case ActivityType.walking:
        return 'Santai, cocok untuk aktivitas ringan harian.';
      case ActivityType.jogging:
        return 'Tempo stabil untuk latihan kardio menengah.';
      case ActivityType.lightRunning:
        return 'Lebih cepat untuk sesi latihan singkat.';
    }
  }

  IconData get icon {
    switch (this) {
      case ActivityType.walking:
        return Icons.directions_walk_rounded;
      case ActivityType.jogging:
        return Icons.directions_run_rounded;
      case ActivityType.lightRunning:
        return Icons.bolt_rounded;
    }
  }

  Color get color {
    switch (this) {
      case ActivityType.walking:
        return const Color(0xFF179C77);
      case ActivityType.jogging:
        return const Color(0xFF2C7BE5);
      case ActivityType.lightRunning:
        return const Color(0xFF0F5B91);
    }
  }

  double get metValue {
    switch (this) {
      case ActivityType.walking:
        return 3.5;
      case ActivityType.jogging:
        return 7.0;
      case ActivityType.lightRunning:
        return 8.3;
    }
  }
}
