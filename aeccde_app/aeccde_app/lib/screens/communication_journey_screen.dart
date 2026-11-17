import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class CommunicationJourneyScreen extends StatelessWidget {
  const CommunicationJourneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: Column(
        children: [
          // Celebratory Header
          Container(
            padding: const EdgeInsets.fromLTRB(24, 80, 24, 40),
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF534AE3), Color(0xFF1A174D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
              children: [
                FadeInDown(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white12, width: 2),
                    ),
                    child: const Center(
                      child: Text('🚀', style: TextStyle(fontSize: 50)),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Your Communication\nJourney',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold, height: 1.2),
                ),
                const SizedBox(height: 12),
                const Text(
                  "You've made incredible progress!",
                  style: TextStyle(color: Colors.white60, fontSize: 16),
                ),
                const SizedBox(height: 40),
                
                // Progress Comparison
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildProgressStat('Started', '82'),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const Icon(Icons.arrow_forward_rounded, color: Color(0xFF00BFA5), size: 24),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: const Color(0xFF00BFA5).withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                            child: const Text('+7 pts', style: TextStyle(color: Color(0xFF00BFA5), fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    _buildProgressStat('Current', '89'),
                  ],
                ),
                const SizedBox(height: 32),
                // Small Waveform
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    12,
                    (i) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: 4,
                      height: 8 + (i % 4 * 6).toDouble(),
                      decoration: BoxDecoration(color: const Color(0xFF00BFA5).withOpacity(0.5), borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Category Improvement',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
                  ),
                  const SizedBox(height: 24),
                  
                  _buildJourneyMetric('Fluency', 84, '+6', '78', Icons.bolt_rounded, const Color(0xFFFF9100)),
                  _buildJourneyMetric('Grammar', 78, '+6', '72', Icons.edit_note_rounded, const Color(0xFF9C27B0)),
                  _buildJourneyMetric('Pronunciation', 86, '+5', '81', Icons.abc_rounded, const Color(0xFF2979FF)),
                  _buildJourneyMetric('Confidence', 80, '+6', '74', Icons.fitness_center_rounded, const Color(0xFFF9A825)),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStat(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildJourneyMetric(String label, int value, String change, String start, IconData icon, Color color) {
    return FadeInUp(
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(label, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 15)),
                ),
                Row(
                  children: [
                    const Icon(Icons.trending_up_rounded, size: 14, color: Color(0xFF00BFA5)),
                    const SizedBox(width: 4),
                    Text(change, style: const TextStyle(color: Color(0xFF00BFA5), fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearPercentIndicator(
              lineHeight: 8,
              percent: value / 100,
              backgroundColor: Colors.grey.shade100,
              progressColor: const Color(0xFF534AE3),
              barRadius: const Radius.circular(4),
              padding: EdgeInsets.zero,
              animation: true,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$start → $value', style: TextStyle(color: Colors.grey.shade400, fontSize: 11, fontWeight: FontWeight.w500)),
                Text('/ 100', style: TextStyle(color: Colors.grey.shade400, fontSize: 11, fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
