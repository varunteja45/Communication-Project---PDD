import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import '../models/evaluation_result.dart';
import 'strengths_screen.dart';

class ConfidenceBehaviorScreen extends StatelessWidget {
  final EvaluationResult? result;

  const ConfidenceBehaviorScreen({super.key, this.result});

  @override
  Widget build(BuildContext context) {
    final conf = result?.confidenceScore.round() ?? 80;

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
          'Confidence & Behavior',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Behavioral Analysis Container
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Behavioral Analysis',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  _buildBehaviorRow('Confidence Score', conf, Icons.fitness_center_rounded, const Color(0xFF534AE3)),
                  _buildBehaviorRow('Eye Contact', (conf - 5).clamp(0, 100), Icons.visibility_rounded, const Color(0xFF2979FF)),
                  _buildBehaviorRow('Facial Engagement', (conf + 2).clamp(0, 100), Icons.sentiment_satisfied_alt_rounded, const Color(0xFF00BFA5)),
                  _buildBehaviorRow('Posture Indicator', (conf - 10).clamp(0, 100), Icons.accessibility_new_rounded, const Color(0xFF7A6FFF)),
                  _buildBehaviorRow('Gesture Activity', (conf - 15).clamp(0, 100), Icons.front_hand_rounded, const Color(0xFF00ACC1)),
                  _buildBehaviorRow('Speaking Consistency', conf, Icons.campaign_rounded, const Color(0xFFE65100)),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // AI Observation Box
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
                      'Your delivery achieved a confidence score of $conf/100. Improving posture and deliberate hand gestures will significantly enhance your overall presence.',
                      style: const TextStyle(color: Color(0xFF1A1A1A), height: 1.5, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Button
            FadeInUp(
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StrengthsScreen(result: result)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF534AE3),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('View Strengths & Improvements', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildBehaviorRow(String label, int value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.orange.shade300),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500)),
                    Text('$value', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (value / 100).clamp(0.0, 1.0),
                    backgroundColor: Colors.grey.shade100,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
