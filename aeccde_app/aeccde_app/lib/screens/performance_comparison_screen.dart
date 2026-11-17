import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class PerformanceComparisonScreen extends StatelessWidget {
  const PerformanceComparisonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Performance Comparison',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Summary Row
            Row(
              children: [
                _buildSummaryBox('75', 'Previous', const Color(0xFFF8F9FF), Colors.grey.shade600),
                const SizedBox(width: 12),
                _buildSummaryBox('+7', 'Change', const Color(0xFFF1F8F1), Colors.green),
                const SizedBox(width: 12),
                _buildSummaryBox('82', 'Current', const Color(0xFFF0F2FF), const Color(0xFF534AE3)),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Category Comparison Chart
            Container(
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
                  const Text('Category Comparison', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 20),
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
                                const labels = ['Fluency', 'Grammar', 'Vocabulary', 'Content'];
                                if (v >= 0 && v < labels.length) {
                                  return Padding(padding: const EdgeInsets.only(top: 8), child: Text(labels[v.toInt()], style: const TextStyle(color: Colors.grey, fontSize: 10)));
                                }
                                return const SizedBox();
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: [
                          _makeGroupedBar(0, 78, 84),
                          _makeGroupedBar(1, 72, 78),
                          _makeGroupedBar(2, 75, 79),
                          _makeGroupedBar(3, 74, 83),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLegendItem('Previous', const Color(0xFFC5CAE9)),
                      const SizedBox(width: 24),
                      _buildLegendItem('Current', const Color(0xFF534AE3)),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Score Breakdown
            Container(
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
                  const Text('Score Breakdown', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 24),
                  _buildBreakdownRow('Fluency', 84, '+6'),
                  _buildBreakdownRow('Grammar', 78, '+6'),
                  _buildBreakdownRow('Pronunciation', 86, '+5'),
                  _buildBreakdownRow('Vocabulary', 79, '+4'),
                  _buildBreakdownRow('Confidence', 80, '+6'),
                  _buildBreakdownRow('Content', 83, '+4'),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Overall Improvement
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F8F1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: const [
                  Text(
                    '+9.3%',
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Color(0xFF00BFA5)),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryBox(String value, String label, Color bgColor, Color textColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _makeGroupedBar(int x, double y1, double y2) {
    return BarChartGroupData(
      x: x,
      barsSpace: 4,
      barRods: [
        BarChartRodData(toY: y1, color: const Color(0xFFC5CAE9), width: 12, borderRadius: BorderRadius.circular(4)),
        BarChartRodData(toY: y2, color: const Color(0xFF534AE3), width: 12, borderRadius: BorderRadius.circular(4)),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildBreakdownRow(String label, int value, String change) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500)),
          ),
          Expanded(
            flex: 6,
            child: LinearPercentIndicator(
              lineHeight: 8,
              percent: value / 100,
              backgroundColor: Colors.grey.shade50,
              progressColor: const Color(0xFF534AE3),
              barRadius: const Radius.circular(4),
              padding: EdgeInsets.zero,
              animation: true,
            ),
          ),
          const SizedBox(width: 16),
          Row(
            children: [
              const Icon(Icons.trending_up_rounded, size: 14, color: Color(0xFF00BFA5)),
              const SizedBox(width: 4),
              Text(change, style: const TextStyle(color: Color(0xFF00BFA5), fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
