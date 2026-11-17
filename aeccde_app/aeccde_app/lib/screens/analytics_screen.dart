import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../providers/session_provider.dart';
import 'performance_comparison_screen.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String selectedFilter = 'This Week';

  @override
  Widget build(BuildContext context) {
    final sessionProvider = context.watch<SessionProvider>();
    final hasData = sessionProvider.history.isNotEmpty;
    final avgScore = hasData ? sessionProvider.averageScore.roundToDouble() : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2E2A6E), Color(0xFF1A174D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Analytics',
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your Communication Analytics',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  
                  // Overall Score Card
                  _buildOverallScoreCard(avgScore, hasData),
                  
                  const SizedBox(height: 32),
                  
                  // Filters
                  _buildFilters(),
                  
                  const SizedBox(height: 32),
                  
                  // Score Trend
                  _buildWeeklyTrend(sessionProvider, hasData),
                  
                  const SizedBox(height: 32),
                  
                  // Radar Chart
                  _buildCategoryRadar(sessionProvider, hasData),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallScoreCard(double avgScore, bool hasData) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Row(
        children: [
          CircularPercentIndicator(
            radius: 50.0,
            lineWidth: 8.0,
            percent: hasData ? (avgScore / 100).clamp(0.0, 1.0) : 0.0,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(hasData ? "${avgScore.toInt()}" : "0", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const Text("Score", style: TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: const Color(0xFF534AE3),
            backgroundColor: const Color(0xFFF0F2FF),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Overall Score', style: TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 4),
                Text(hasData ? '${avgScore.toInt()} / 100' : '0 / 100', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.arrow_upward_rounded, size: 16, color: Color(0xFF00BFA5)),
                    const SizedBox(width: 4),
                    Text(hasData ? '+7% improved' : '0% improved', style: const TextStyle(color: Color(0xFF00BFA5), fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
                Text(hasData ? 'Since you started' : 'No evaluations yet', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                const SizedBox(height: 12),
                if (hasData)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const PerformanceComparisonScreen()));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF534AE3).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Compare with Previous →',
                        style: TextStyle(color: Color(0xFF534AE3), fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      children: ['This Week', 'This Month', 'All Time'].map((f) {
        final isSelected = selectedFilter == f;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => selectedFilter = f),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF534AE3) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.shade200),
              ),
              child: Center(
                child: Text(
                  f,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey.shade600,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildWeeklyTrend(SessionProvider sessionProvider, bool hasData) {
    final history = sessionProvider.history;
    List<FlSpot> spots = const [
      FlSpot(0, 0), FlSpot(1, 0), FlSpot(2, 0), FlSpot(3, 0), FlSpot(4, 0), FlSpot(5, 0), FlSpot(6, 0),
    ];

    if (hasData) {
      final recent = history.take(7).toList().reversed.toList();
      spots = List.generate(recent.length, (i) => FlSpot(i.toDouble(), recent[i].overallScore));
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Weekly Score Trend', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 32),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 10),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 20,
                      getTitlesWidget: (v, m) => Text(v.toInt().toString(), style: const TextStyle(color: Colors.grey, fontSize: 10)),
                      reservedSize: 24,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, m) {
                        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                        if (v >= 0 && v < days.length) {
                          return Padding(padding: const EdgeInsets.only(top: 8), child: Text(days[v.toInt()], style: const TextStyle(color: Colors.grey, fontSize: 10)));
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (spots.length - 1).clamp(1, 6).toDouble(),
                minY: 0,
                maxY: 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: const Color(0xFF534AE3),
                    barWidth: 3,
                    dotData: FlDotData(show: hasData),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRadar(SessionProvider sessionProvider, bool hasData) {
    final averages = sessionProvider.competencyAverages;
    final f = hasData ? (averages['Fluency'] ?? 0) : 0.0;
    final g = hasData ? (averages['Grammar'] ?? 0) : 0.0;
    final v = hasData ? (averages['Vocabulary'] ?? 0) : 0.0;
    final p = hasData ? (averages['Clarity'] ?? 0) : 0.0;
    final c = hasData ? (averages['Confidence'] ?? 0) : 0.0;
    final cl = hasData ? (averages['Pace'] ?? 0) : 0.0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Category Performance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 32),
          AspectRatio(
            aspectRatio: 1.3,
            child: RadarChart(
              RadarChartData(
                radarShape: RadarShape.polygon,
                tickCount: 4,
                ticksTextStyle: const TextStyle(color: Colors.transparent),
                radarBorderData: const BorderSide(color: Colors.transparent),
                gridBorderData: BorderSide(color: Colors.grey.shade200, width: 1),
                radarBackgroundColor: Colors.transparent,
                getTitle: (index, angle) {
                  const labels = ['Fluency', 'Grammar', 'Vocab', 'Pronunciation', 'Confidence', 'Pace'];
                  return RadarChartTitle(text: labels[index]);
                },
                titleTextStyle: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w500),
                dataSets: [
                  RadarDataSet(
                    fillColor: const Color(0xFF534AE3).withOpacity(0.2),
                    borderColor: const Color(0xFF534AE3),
                    borderWidth: 2,
                    entryRadius: 3,
                    dataEntries: [
                      RadarEntry(value: f),
                      RadarEntry(value: g),
                      RadarEntry(value: v),
                      RadarEntry(value: p),
                      RadarEntry(value: c),
                      RadarEntry(value: cl),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
