import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import '../models/evaluation_result.dart';
import '../widgets/analysis_metric_tile.dart';

class EmotionAnalysisScreen extends StatelessWidget {
  final EvaluationResult? result;

  const EmotionAnalysisScreen({super.key, this.result});

  @override
  Widget build(BuildContext context) {
    final conf = result?.confidenceScore.round() ?? 80;
    final clarity = result?.clarityScore.round() ?? 89;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Emotion Analysis',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20, top: 12, bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFEDEEFC),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Live AI',
                  style: TextStyle(color: Color(0xFF534AE3), fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 16),
            
            // Emotion Header Area
            FadeInDown(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10)),
                  ],
                ),
                child: Column(
                  children: [
                    // Scanner Visualization
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        ..._buildScannerCorners(),
                        Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF0F2FF),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text('😊', style: TextStyle(fontSize: 50)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Dominant Expression',
                      style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Confident & Engaged',
                      style: TextStyle(color: Color(0xFF534AE3), fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            FadeInUp(
              delay: const Duration(milliseconds: 100),
              child: AnalysisMetricTile(
                label: 'Confidence Level',
                value: '$conf%',
                progress: (conf / 100).clamp(0.0, 1.0),
                darkTheme: false,
                icon: Icons.thumb_up_alt_rounded,
              ),
            ),
            
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: AnalysisMetricTile(
                label: 'Vocal Clarity',
                value: '$clarity%',
                progress: (clarity / 100).clamp(0.0, 1.0),
                darkTheme: false,
                icon: Icons.sentiment_satisfied_rounded,
              ),
            ),
            
            FadeInUp(
              delay: const Duration(milliseconds: 300),
              child: const AnalysisMetricTile(
                label: 'Engagement Rate',
                value: '88%',
                progress: 0.88,
                darkTheme: false,
                icon: Icons.bolt_rounded,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Warning Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9E6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Text('✨', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Emotion indicators are behavioral signals calculated on-device.',
                      style: TextStyle(fontSize: 11, color: Colors.orange.shade900, fontWeight: FontWeight.w500),
                    ),
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

  List<Widget> _buildScannerCorners() {
    const double size = 30;
    const color = Color(0xFFE0E4FF);
    return [
      Positioned(top: 0, left: 0, child: Container(width: size, height: size, decoration: const BoxDecoration(border: Border(top: BorderSide(color: color, width: 2), left: BorderSide(color: color, width: 2))))),
      Positioned(top: 0, right: 0, child: Container(width: size, height: size, decoration: const BoxDecoration(border: Border(top: BorderSide(color: color, width: 2), right: BorderSide(color: color, width: 2))))),
      Positioned(bottom: 0, left: 0, child: Container(width: size, height: size, decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: color, width: 2), left: BorderSide(color: color, width: 2))))),
      Positioned(bottom: 0, right: 0, child: Container(width: size, height: size, decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: color, width: 2), right: BorderSide(color: color, width: 2))))),
    ];
  }
}
