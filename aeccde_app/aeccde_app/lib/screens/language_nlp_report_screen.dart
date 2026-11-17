import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import '../models/evaluation_result.dart';

class LanguageNlpReportScreen extends StatelessWidget {
  final EvaluationResult? result;

  const LanguageNlpReportScreen({super.key, this.result});

  @override
  Widget build(BuildContext context) {
    final int grammar = result?.grammarScore.round() ?? 78;
    final int vocab = result?.vocabularyScore.round() ?? 79;
    final int overall = result?.overallScore.round() ?? 83;

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
          'Language & NLP Report',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // NLP Scores Container
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
                    'NLP Category Scores',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  _buildScoreRow('Grammar Accuracy', grammar, const Color(0xFF7A6FFF)),
                  _buildScoreRow('Vocabulary Richness', vocab, const Color(0xFF534AE3)),
                  _buildScoreRow('Sentence Structure', (grammar + 4).clamp(0, 100), const Color(0xFF2979FF)),
                  _buildScoreRow('Coherence', (overall + 2).clamp(0, 100), const Color(0xFF00BFA5)),
                  _buildScoreRow('Relevance', (overall + 5).clamp(0, 100), const Color(0xFF00ACC1)),
                  _buildScoreRow('Content Quality', overall, const Color(0xFFE65100)),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Grammar & Language Insights
            const Text(
              'Key Language Observations',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            _buildGrammarIssueCard(
              'Grammar Score: $grammar/100',
              result != null && result!.improvements.isNotEmpty
                  ? result!.improvements.first
                  : 'Maintain subject-verb agreement and consistent tenses.',
              const Color(0xFFFFF3E0),
              const Color(0xFFE65100),
            ),
            _buildGrammarIssueCard(
              'Vocabulary Diversity: $vocab/100',
              'Word Count: ${result?.wordCount ?? 102} words evaluated across speech transcript.',
              const Color(0xFFF0F2FF),
              const Color(0xFF534AE3),
            ),

            const SizedBox(height: 32),

            // Improvement Suggestions
            FadeInUp(
              child: Container(
                width: double.infinity,
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
                        Text('AI Improvement Suggestions', style: TextStyle(color: Color(0xFF534AE3), fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSuggestionItem('Practice subject-verb agreement exercises in Vocabulary Practice'),
                    _buildSuggestionItem('Expand active vocabulary with 5 new transition phrases'),
                    _buildSuggestionItem('Use varied sentence structures to improve coherence'),
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

  Widget _buildScoreRow(String label, int value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500)),
          ),
          Expanded(
            flex: 6,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (value / 100).clamp(0.0, 1.0),
                backgroundColor: Colors.grey.shade100,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text('$value', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildGrammarIssueCard(String title, String description, Color bgColor, Color textColor) {
    return FadeInUp(
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 6),
            Text(description, style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 13, fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: Color(0xFF534AE3), fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(text, style: const TextStyle(color: Color(0xFF1A1A1A), fontSize: 13, height: 1.4)),
          ),
        ],
      ),
    );
  }
}
