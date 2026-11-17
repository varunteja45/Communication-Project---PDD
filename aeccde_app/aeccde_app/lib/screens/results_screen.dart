import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import '../models/evaluation_result.dart';
import '../models/question_evaluation.dart';
import '../theme/app_theme.dart';
import '../widgets/score_radar_chart.dart';
import '../widgets/metric_tile.dart';
import 'overall_report_screen.dart';
import 'speech_analysis_screen.dart';
import 'language_nlp_report_screen.dart';
import 'confidence_behavior_screen.dart';
import 'pronunciation_report_screen.dart';
import 'strengths_screen.dart';
import 'areas_to_improve_screen.dart';
import 'ai_coach_feedback_screen.dart';
import 'seven_day_plan_screen.dart';

class ResultsScreen extends StatelessWidget {
  final EvaluationResult result;

  const ResultsScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
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
          'Evaluation Results',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall Score Header
            _buildScoreHeader(context),
            const SizedBox(height: 32),

            // Deep-Link Report Shortcuts
            const Text(
              'Detailed AI Reports',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildReportChip(
                    context,
                    label: 'Overall Report',
                    icon: Icons.bar_chart_rounded,
                    color: const Color(0xFF534AE3),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => OverallReportScreen(result: result))),
                  ),
                  _buildReportChip(
                    context,
                    label: 'Speech Analysis',
                    icon: Icons.mic_rounded,
                    color: const Color(0xFF00B0FF),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SpeechAnalysisScreen(result: result))),
                  ),
                  _buildReportChip(
                    context,
                    label: 'Language & NLP',
                    icon: Icons.spellcheck_rounded,
                    color: const Color(0xFF9C27B0),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LanguageNlpReportScreen(result: result))),
                  ),
                  _buildReportChip(
                    context,
                    label: 'Pronunciation',
                    icon: Icons.record_voice_over_rounded,
                    color: const Color(0xFF00ACC1),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PronunciationReportScreen(result: result))),
                  ),
                  _buildReportChip(
                    context,
                    label: 'Emotion & Behavior',
                    icon: Icons.sentiment_satisfied_alt_rounded,
                    color: const Color(0xFF00BFA5),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ConfidenceBehaviorScreen(result: result))),
                  ),
                  _buildReportChip(
                    context,
                    label: 'AI Coach Feedback',
                    icon: Icons.auto_awesome,
                    color: const Color(0xFFFF9100),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AiCoachFeedbackScreen(result: result))),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Question-by-Question Evaluation Breakdown
            if (result.questionEvaluations.isNotEmpty) ...[
              const Text(
                'Question-by-Question Evaluation',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...result.questionEvaluations.map((q) => _buildQuestionCard(q)),
              const SizedBox(height: 32),
            ],

            // Radar Chart Section
            FadeInDown(
              duration: const Duration(milliseconds: 600),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FF),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0xFFE0E4FF)),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Competency Radar',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    ScoreRadarChart(data: result.radarData),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Competency List
            const Text(
              'Detailed Sub-Scores',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildMetricList(),
            const SizedBox(height: 32),

            // Feedback Sections
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StrengthsScreen(result: result))),
              child: _buildFeedbackSection(
                title: 'Strengths (Tap for Details)',
                items: result.strengths,
                color: AppTheme.accentTeal,
                icon: Icons.check_circle_outline_rounded,
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AreasToImproveScreen(result: result))),
              child: _buildFeedbackSection(
                title: 'Areas for Improvement (Tap for Details)',
                items: result.improvements,
                color: AppTheme.accentRed,
                icon: Icons.trending_up_rounded,
              ),
            ),
            const SizedBox(height: 32),

            // Action Buttons
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SevenDayPlanScreen(result: result))),
                icon: const Icon(Icons.calendar_today_rounded, color: Colors.white, size: 20),
                label: const Text('View 7-Day Improvement Plan', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF534AE3),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Back to Home', style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(QuestionEvaluation q) {
    final isZero = q.score == 0.0 || !q.isAnswered;
    final color = isZero ? Colors.redAccent : AppTheme.scoreColor(q.score);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF534AE3).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Q${q.questionIndex}',
                  style: const TextStyle(color: Color(0xFF534AE3), fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  q.questionText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${q.score.toInt()}/100',
                  style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            decoration: BoxDecoration(
              color: isZero ? const Color(0xFFFFEBEE) : const Color(0xFFF8F9FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Answer: ${q.transcript}',
              style: TextStyle(
                color: isZero ? Colors.red.shade800 : Colors.grey.shade800,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Feedback: ${q.feedback}',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildReportChip(BuildContext context, {required String label, required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreHeader(BuildContext context) {
    return FadeIn(
      duration: const Duration(milliseconds: 800),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF534AE3), Color(0xFF7A6FFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF534AE3).withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  result.overallScore.toStringAsFixed(0),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'OVERALL',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.band,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Based on speech rhythm, vocabulary, and clarity.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricList() {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Column(
        children: [
          MetricTile(label: 'Fluency', score: result.fluencyScore, icon: Icons.bolt_rounded),
          MetricTile(label: 'Vocabulary', score: result.vocabularyScore, icon: Icons.menu_book_rounded),
          MetricTile(label: 'Grammar', score: result.grammarScore, icon: Icons.spellcheck_rounded),
          MetricTile(label: 'Pace', score: result.paceScore, icon: Icons.speed_rounded),
          MetricTile(label: 'Confidence', score: result.confidenceScore, icon: Icons.psychology_rounded),
          MetricTile(label: 'Clarity', score: result.clarityScore, icon: Icons.record_voice_over_rounded),
        ],
      ),
    );
  }

  Widget _buildFeedbackSection({
    required String title,
    required List<String> items,
    required Color color,
    required IconData icon,
  }) {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right_rounded, color: color, size: 20),
              ],
            ),
            const SizedBox(height: 12),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Icon(Icons.fiber_manual_record, size: 8, color: Colors.grey),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade800, height: 1.4),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
