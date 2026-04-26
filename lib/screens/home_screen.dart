import 'package:flutter/material.dart';

import '../models/activity_type.dart';
import '../widgets/activity_option_card.dart';
import '../widgets/metric_card.dart';
import 'tracking_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ActivityType _selectedActivity = ActivityType.walking;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0D685A), Color(0xFF169C77)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.favorite_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'PulseRun',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Aplikasi monitoring aktivitas olahraga sederhana dengan accelerometer, gyroscope, dan GPS.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Pilih Jenis Olahraga',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              ...ActivityType.values.map(
                (activity) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ActivityOptionCard(
                    type: activity,
                    isSelected: _selectedActivity == activity,
                    onTap: () {
                      setState(() {
                        _selectedActivity = activity;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Sensor yang Digunakan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF12313A),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Accelerometer untuk estimasi langkah, gyroscope untuk membaca perubahan gerak/orientasi, dan GPS untuk jarak, kecepatan, serta koordinat.',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: const [
                  Expanded(
                    child: MetricCard(
                      title: 'Sensor',
                      value: '3',
                      subtitle: 'aktif saat tracking',
                      icon: Icons.sensors_rounded,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: MetricCard(
                      title: 'Aktivitas',
                      value: '3',
                      subtitle: 'jalan, jogging, lari',
                      icon: Icons.directions_run_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          TrackingScreen(activityType: _selectedActivity),
                    ),
                  );
                },
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Mulai Aktivitas'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
