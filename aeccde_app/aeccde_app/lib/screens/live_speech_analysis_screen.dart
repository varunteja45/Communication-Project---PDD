import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../widgets/analysis_metric_tile.dart';
import 'emotion_analysis_screen.dart';
import 'evaluation_completed_screen.dart';

class LiveSpeechAnalysisScreen extends StatelessWidget {
  const LiveSpeechAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0D25),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Live Speech Analysis',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20, top: 12, bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                const Text(
                  'LIVE',
                  style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold),
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
            const SizedBox(height: 20),
            
            // Big Waveform Area
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EmotionAnalysisScreen()),
                );
              },
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white10),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      15,
                      (i) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        width: 4,
                        height: 20 + (i % 5 * 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00BFA5),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            FadeInUp(
              child: const AnalysisMetricTile(
                label: 'Speaking Speed',
                value: 'Normal',
                progress: 0.65,
                showBadge: true,
                badgeText: 'Good pace',
                badgeColor: Colors.green,
              ),
            ),
            
            FadeInUp(
              delay: const Duration(milliseconds: 100),
              child: const AnalysisMetricTile(
                label: 'Fluency',
                value: '84%',
                progress: 0.84,
                showBadge: true,
                badgeText: 'Good fluency',
                badgeColor: Colors.green,
              ),
            ),
            
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: const AnalysisMetricTile(
                label: 'Filler Words',
                value: '3',
                progress: 0.35,
                showBadge: true,
                badgeText: 'Reduce fillers',
                badgeColor: Colors.orange,
              ),
            ),
            
            FadeInUp(
              delay: const Duration(milliseconds: 300),
              child: const AnalysisMetricTile(
                label: 'Pause Duration',
                value: '1.2s avg',
                progress: 0.6,
                showBadge: true,
                badgeText: 'Natural pauses',
                badgeColor: Colors.green,
              ),
            ),
            
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: const AnalysisMetricTile(
                label: 'Pronunciation',
                value: '88%',
                progress: 0.88,
                showBadge: true,
                badgeText: 'Clear',
                badgeColor: Colors.green,
              ),
            ),
            
            FadeInUp(
              delay: const Duration(milliseconds: 500),
              child: const AnalysisMetricTile(
                label: 'Confidence',
                value: '80%',
                progress: 0.8,
                showBadge: true,
                badgeText: 'Confident',
                badgeColor: Colors.green,
              ),
            ),
            
            const SizedBox(height: 32),
            
            SizedBox(
              width: double.infinity,
              height: 64,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EvaluationCompletedScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5252),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text(
                  'Stop & Get Results',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
