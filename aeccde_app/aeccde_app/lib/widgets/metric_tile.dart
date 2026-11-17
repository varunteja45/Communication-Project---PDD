import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../theme/app_theme.dart';

class MetricTile extends StatelessWidget {
  final String label;
  final double score;
  final IconData icon;

  const MetricTile({super.key, required this.label, required this.score, required this.icon});

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.scoreColor(score);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 10),
          SizedBox(
            width: 90,
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Expanded(
            child: LinearPercentIndicator(
              lineHeight: 10,
              percent: (score / 100).clamp(0, 1),
              backgroundColor: color.withOpacity(0.12),
              progressColor: color,
              barRadius: const Radius.circular(8),
              padding: EdgeInsets.zero,
              animation: true,
              animationDuration: 700,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 36,
            child: Text(
              score.toStringAsFixed(0),
              textAlign: TextAlign.end,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w700, color: color),
            ),
          ),
        ],
      ),
    );
  }
}
