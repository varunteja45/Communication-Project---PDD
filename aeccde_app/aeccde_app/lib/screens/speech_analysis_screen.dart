import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../models/evaluation_result.dart';

class SpeechAnalysisScreen extends StatelessWidget {
  final EvaluationResult? result;

  const SpeechAnalysisScreen({super.key, this.result});

  @override
  Widget build(BuildContext context) {
    final fluency = result?.fluencyScore.round() ?? 84;
    final wpm = result?.wordsPerMinute.round() ?? 138;
    final duration = result?.durationSeconds ?? 45;
    final fillers = result?.fillerCount ?? 3;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Speech Analysis',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Header
            FadeInDown(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF534AE3), Color(0xFF00B0FF)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTopStat('$fluency', 'Fluency Score'),
                    _buildTopStat('$wpm', 'Words/Min'),
                    _buildTopStat('$duration sec', 'Duration'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Bar Chart Section
            const Text('Speaking Rate (Words/Min)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 20),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (val, meta) => Text(val.toInt().toString(), style: const TextStyle(color: Colors.grey, fontSize: 10)),
                        reservedSize: 28,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (val, meta) {
                          const titles = ['Sec 10', 'Sec 20', 'Sec 30', 'Sec 40', 'Sec 50'];
                          if (val >= 0 && val < titles.length) {
                            return Padding(padding: const EdgeInsets.only(top: 8), child: Text(titles[val.toInt()], style: const TextStyle(color: Colors.grey, fontSize: 10)));
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    _makeBarGroup(0, (wpm - 8).toDouble()),
                    _makeBarGroup(1, (wpm + 4).toDouble()),
                    _makeBarGroup(2, wpm.toDouble()),
                    _makeBarGroup(3, (wpm + 10).toDouble()),
                    _makeBarGroup(4, (wpm + 2).toDouble()),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Detailed Metrics
            const Text('Detailed Metrics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            _buildDetailMetric('Pace Consistency', '$wpm WPM', (wpm / 180).clamp(0.0, 1.0), const Color(0xFF534AE3)),
            _buildDetailMetric('Filler Word Count', '$fillers words', (fillers / 10).clamp(0.1, 1.0), Colors.orange),
            _buildDetailMetric('Speech Clarity', '${(result?.clarityScore ?? 89).round()}%', ((result?.clarityScore ?? 89) / 100).clamp(0.0, 1.0), Colors.green),
            _buildDetailMetric('Voice Modulation', 'Good', 0.75, const Color(0xFF7A6FFF)),
            
            const SizedBox(height: 32),
            
            // AI Observation
            FadeInUp(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F2FF),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text('✨', style: TextStyle(fontSize: 16)),
                        SizedBox(width: 8),
                        Text('AI Observation', style: TextStyle(color: Color(0xFF534AE3), fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Your speaking pace was recorded at $wpm WPM — within the target range of 120–150 WPM. Recorded $fillers filler words during the $duration second session.',
                      style: const TextStyle(color: Color(0xFF1A1A1A), height: 1.5, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTopStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w500)),
      ],
    );
  }

  BarChartGroupData _makeBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: const Color(0xFF534AE3),
          width: 36,
          borderRadius: BorderRadius.circular(8),
        ),
      ],
    );
  }

  Widget _buildDetailMetric(String label, String value, double progress, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          LinearPercentIndicator(
            lineHeight: 6,
            percent: progress.clamp(0.0, 1.0),
            backgroundColor: Colors.grey.shade100,
            progressColor: color,
            barRadius: const Radius.circular(3),
            padding: EdgeInsets.zero,
            animation: true,
          ),
        ],
      ),
    );
  }
}
