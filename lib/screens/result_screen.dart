import 'package:flutter/material.dart';

import '../models/activity_result.dart';
import '../models/activity_type.dart';
import '../widgets/metric_card.dart';
import 'home_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.result});

  final ActivityResult result;

  @override
  Widget build(BuildContext context) {
    final metrics = result.metrics;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Hasil Aktivitas'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ringkasan Olahraga',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF12313A),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      result.type.label,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF12313A),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Data di bawah adalah hasil tracking sederhana dan beberapa nilai merupakan estimasi simulasi untuk pembelajaran.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: MediaQuery.sizeOf(context).width / 2 - 26,
                  child: MetricCard(
                    title: 'Durasi',
                    value: _formatDuration(metrics.duration),
                    subtitle: 'total waktu',
                    icon: Icons.timer_outlined,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width / 2 - 26,
                  child: MetricCard(
                    title: 'Jarak',
                    value: '${(metrics.distanceMeters / 1000).toStringAsFixed(2)} km',
                    subtitle: 'total lintasan',
                    icon: Icons.route_rounded,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width / 2 - 26,
                  child: MetricCard(
                    title: 'Langkah',
                    value: '${metrics.steps}',
                    subtitle: 'estimasi langkah',
                    icon: Icons.directions_walk_rounded,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width / 2 - 26,
                  child: MetricCard(
                    title: 'Rata-rata',
                    value: '${metrics.averageSpeedKmh.toStringAsFixed(1)} km/j',
                    subtitle: 'kecepatan rata-rata',
                    icon: Icons.speed_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            MetricCard(
              title: 'Kalori',
              value: '${result.calories.toStringAsFixed(1)} kcal',
              subtitle: 'estimasi berdasarkan durasi dan jenis aktivitas',
              icon: Icons.local_fire_department_rounded,
              fullWidth: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  HomeScreen.routeName,
                  (route) => false,
                );
              },
              icon: const Icon(Icons.home_rounded),
              label: const Text('Kembali ke Halaman Utama'),
            ),
          ],
        ),
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
