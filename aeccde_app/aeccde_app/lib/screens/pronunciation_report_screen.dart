import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import '../models/evaluation_result.dart';

class PronunciationReportScreen extends StatelessWidget {
  final EvaluationResult? result;

  const PronunciationReportScreen({super.key, this.result});

  @override
  Widget build(BuildContext context) {
    final pron = result?.clarityScore.round() ?? 88;

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
          'Pronunciation Report',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Accuracy Card
            FadeInDown(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00ACC1), Color(0xFF534AE3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white30, width: 4),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('$pron', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                          const Text('Accuracy', style: TextStyle(color: Colors.white70, fontSize: 8)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Overall Pronunciation', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('$pron%', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('Words Evaluated: ${result?.wordCount ?? 20}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            const Text('Word-by-Word Analysis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            _buildDetailedWordCard('Communication', '/kəˌmju:nɪˈkeɪʃən/', '/kəˌmju:nɪˈkeɪʃən/', true),
            _buildDetailedWordCard('Opportunity', '/ˌɒpəˈtju:nɪti/', '/ˌɑ:pərˈtu:nɪti/', pron >= 85),
            _buildDetailedWordCard('Professional', '/prəˈfɛʃənəl/', '/prəˈfɛʃənəl/', true),
            _buildDetailedWordCard('Articulate', '/ɑ:ˈtɪkjʊlɪt/', '/ɑ:ˈtɪkjʊlɪt/', true),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedWordCard(String word, String detected, String suggested, bool isCorrect) {
    return FadeInUp(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isCorrect ? const Color(0xFFF1F8F1) : const Color(0xFFFFF9E6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isCorrect ? const Color(0xFFE8F5E9) : const Color(0xFFFFF1CC)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(word, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isCorrect ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(isCorrect ? Icons.check_rounded : Icons.warning_amber_rounded, size: 12, color: isCorrect ? Colors.green : Colors.orange),
                      const SizedBox(width: 4),
                      Text(
                        isCorrect ? 'Correct' : 'Practice',
                        style: TextStyle(color: isCorrect ? Colors.green : Colors.orange, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                children: [
                  const TextSpan(text: 'Detected: '),
                  TextSpan(text: detected, style: const TextStyle(color: Color(0xFF534AE3), fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                children: [
                  const TextSpan(text: 'Suggested: '),
                  TextSpan(text: suggested, style: const TextStyle(color: Color(0xFF7A6FFF), fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
