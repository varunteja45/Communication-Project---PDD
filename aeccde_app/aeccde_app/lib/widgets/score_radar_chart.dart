import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Six-axis radar chart visualizing the competency breakdown
/// (Fluency, Vocabulary, Grammar, Pace, Confidence, Clarity).
class ScoreRadarChart extends StatelessWidget {
  final Map<String, double> data;

  const ScoreRadarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final entries = data.entries.toList();
    return AspectRatio(
      aspectRatio: 1.1,
      child: RadarChart(
        RadarChartData(
          radarShape: RadarShape.polygon,
          tickCount: 4,
          ticksTextStyle: const TextStyle(color: Colors.transparent, fontSize: 0),
          radarBorderData: BorderSide(color: Colors.grey.withOpacity(0.2)),
          gridBorderData: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
          radarBackgroundColor: Colors.transparent,
          titlePositionPercentageOffset: 0.15,
          getTitle: (index, angle) {
            final entry = entries[index];
            return RadarChartTitle(text: entry.key);
          },
          titleTextStyle: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(fontWeight: FontWeight.w600),
          dataSets: [
            RadarDataSet(
              fillColor: AppTheme.accentTeal.withOpacity(0.25),
              borderColor: AppTheme.accentTeal,
              borderWidth: 2.5,
              entryRadius: 3,
              dataEntries: entries.map((e) => RadarEntry(value: e.value)).toList(),
            ),
          ],
        ),
        swapAnimationDuration: const Duration(milliseconds: 600),
      ),
    );
  }
}
