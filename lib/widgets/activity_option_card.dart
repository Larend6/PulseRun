import 'package:flutter/material.dart';

import '../models/activity_type.dart';

class ActivityOptionCard extends StatelessWidget {
  const ActivityOptionCard({
    super.key,
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  final ActivityType type;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: isSelected ? type.color.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? type.color : const Color(0xFFD4E1E8),
            width: isSelected ? 1.4 : 1,
          ),
        ),
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                color: type.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(type.icon, color: type.color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type.label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF12313A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(type.description),
                ],
              ),
            ),
            Icon(
              isSelected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: isSelected ? type.color : const Color(0xFF8AA0AA),
            ),
          ],
        ),
      ),
    );
  }
}
