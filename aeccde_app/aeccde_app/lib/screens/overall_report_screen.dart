import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../models/evaluation_result.dart';
import 'pronunciation_report_screen.dart';
import 'speech_analysis_screen.dart';
import 'language_nlp_report_screen.dart';
import 'confidence_behavior_screen.dart';
import 'ai_coach_feedback_screen.dart';

class OverallReportScreen extends StatelessWidget {
  final EvaluationResult? result;

  const OverallReportScreen({super.key, this.result});

  @override
  Widget build(BuildContext context) {
    final double overall = result?.overallScore ?? 82.0;
    final int fluency = result?.fluencyScore.round() ?? 84;
    final int grammar = result?.grammarScore.round() ?? 78;
    final int vocab = result?.vocabularyScore.round() ?? 79;
    final int pron = result?.clarityScore.round() ?? 86;
    final int conf = result?.confidenceScore.round() ?? 80;

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
          'Overall Report',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          children: [
            // Top Score Card
            FadeInDown(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF534AE3), Color(0xFF7A6FFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    const Text(
                      'OVERALL COMMUNICATION SCORE',
                      style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                    ),
                    const SizedBox(height: 24),
                    CircularPercentIndicator(
                      radius: 70.0,
                      lineWidth: 10.0,
                      percent: (overall / 100).clamp(0.0, 1.0),
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${overall.round()}", style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
                          const Text("/ 100", style: TextStyle(color: Colors.white54, fontSize: 12)),
                        ],
                      ),
                      circularStrokeCap: CircularStrokeCap.round,
                      backgroundColor: Colors.white10,
                      progressColor: const Color(0xFF00BFA5),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Evaluation Mode • ${result?.durationSeconds ?? 45} sec',
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00BFA5).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '↑ Live AI Evaluation',
                        style: TextStyle(color: Color(0xFF00BFA5), fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Category Breakdown
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Category Breakdown',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            
            _buildCategoryRow('Fluency', fluency, const Color(0xFF534AE3), () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => SpeechAnalysisScreen(result: result)));
            }),
            _buildCategoryRow('Grammar', grammar, const Color(0xFF7A6FFF), () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => LanguageNlpReportScreen(result: result)));
            }),
            _buildCategoryRow('Vocabulary', vocab, const Color(0xFF9C27B0), () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => LanguageNlpReportScreen(result: result)));
            }),
            _buildCategoryRow('Pronunciation', pron, const Color(0xFF00ACC1), () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => PronunciationReportScreen(result: result)));
            }),
            _buildCategoryRow('Confidence', conf, const Color(0xFF00897B), () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ConfidenceBehaviorScreen(result: result)));
            }),
            
            const SizedBox(height: 32),
            
            // AI Summary Box
            FadeInUp(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AiCoachFeedbackScreen(result: result)),
                  );
                },
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
                          Text('AI Summary', style: TextStyle(color: Color(0xFF534AE3), fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        result != null && result!.strengths.isNotEmpty
                            ? 'Key Strength: ${result!.strengths.first}. Focus on ${result!.improvements.first} to boost score above 90. Tap for AI Coaching.'
                            : 'Strong performance in Pronunciation and Fluency. Focus on Grammar and Vocabulary to achieve 90+. Tap for detailed AI Coaching.',
                        style: const TextStyle(color: Color(0xFF1A1A1A), height: 1.5, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryRow(String label, int value, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(label, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
            ),
            Expanded(
              flex: 5,
              child: LinearPercentIndicator(
                lineHeight: 8,
                percent: (value / 100).clamp(0.0, 1.0),
                backgroundColor: Colors.grey.shade100,
                progressColor: color,
                barRadius: const Radius.circular(4),
                padding: EdgeInsets.zero,
                animation: true,
              ),
            ),
            const SizedBox(width: 16),
            Text('$value', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
