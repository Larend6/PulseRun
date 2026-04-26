import 'package:flutter/material.dart';

import '../models/activity_type.dart';
import '../services/activity_tracking_service.dart';
import '../widgets/metric_card.dart';
import 'result_screen.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key, required this.activityType});

  final ActivityType activityType;

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  late final ActivityTrackingService _trackingService;

  @override
  void initState() {
    super.initState();
    _trackingService = ActivityTrackingService(activityType: widget.activityType);
    _trackingService.start();
  }

  @override
  void dispose() {
    _trackingService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: AnimatedBuilder(
        animation: _trackingService,
        builder: (context, _) {
          final metrics = _trackingService.metrics;

          return Scaffold(
            appBar: AppBar(
              title: Text(widget.activityType.label),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          widget.activityType.color,
                          widget.activityType.color.withValues(alpha: 0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status Gerakan',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.88),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          metrics.motionStatus,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          metrics.sensorSummary,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.92),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width / 2 - 26,
                        child: MetricCard(
                          title: 'Durasi',
                          value: _formatDuration(metrics.duration),
                          subtitle: 'waktu latihan',
                          icon: Icons.timer_outlined,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width / 2 - 26,
                        child: MetricCard(
                          title: 'Jarak',
                          value:
                              '${(metrics.distanceMeters / 1000).toStringAsFixed(2)} km',
                          subtitle: 'berdasarkan GPS',
                          icon: Icons.route_rounded,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width / 2 - 26,
                        child: MetricCard(
                          title: 'Kecepatan',
                          value:
                              '${metrics.currentSpeedKmh.toStringAsFixed(1)} km/j',
                          subtitle: 'kecepatan saat ini',
                          icon: Icons.speed_rounded,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width / 2 - 26,
                        child: MetricCard(
                          title: 'Langkah',
                          value: '${metrics.steps}',
                          subtitle: 'estimasi sederhana',
                          icon: Icons.directions_walk_rounded,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Status Lokasi',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF12313A),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(metrics.locationStatus),
                          const SizedBox(height: 10),
                          Text(
                            metrics.latitude != null && metrics.longitude != null
                                ? 'Koordinat: ${metrics.latitude!.toStringAsFixed(5)}, ${metrics.longitude!.toStringAsFixed(5)}'
                                : 'Koordinat belum tersedia',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF12313A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  if (!metrics.isPaused) ...[
                    OutlinedButton.icon(
                      onPressed: metrics.isTracking ? _trackingService.pause : null,
                      icon: const Icon(Icons.pause_rounded),
                      label: const Text('Pause'),
                    ),
                  ] else ...[
                    ElevatedButton.icon(
                      onPressed: _trackingService.resume,
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('Lanjutkan'),
                    ),
                  ],
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final result = await _trackingService.finish();
                      if (!context.mounted) {
                        return;
                      }

                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute<void>(
                          builder: (_) => ResultScreen(result: result),
                        ),
                      );
                    },
                    icon: const Icon(Icons.flag_rounded),
                    label: const Text('Selesai'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }
}
