import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import '../models/evaluation_result.dart';

class AreasToImproveScreen extends StatelessWidget {
  final EvaluationResult? result;

  const AreasToImproveScreen({super.key, this.result});

  @override
  Widget build(BuildContext context) {
    final improvements = result?.improvements ?? [
      'Reduce filler word usage ("um", "uh")',
      'Refine subject-verb grammar agreement',
      'Maintain strong eye contact and posture',
      'Use structured transition phrases',
    ];

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
          'Areas to Improve',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 32),
            
            // Header
            FadeInDown(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFEEFF2),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text('🎯', style: TextStyle(fontSize: 40)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Areas to Improve',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Focus on these recommendations to level up',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            ...improvements.map((imp) => _buildImprovementCard(
                  imp,
                  'Recommended focus area identified by AI speech analysis.',
                  'Practice in the Practice Dashboard module.',
                  Icons.report_problem_rounded,
                  const Color(0xFFFF9100),
                )),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildImprovementCard(String title, String reason, String action, IconData icon, Color color) {
    return FadeInUp(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
          ],
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(reason, style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.4)),
            const SizedBox(height: 8),
            Text('Action: $action', style: const TextStyle(fontSize: 13, color: Color(0xFF534AE3), fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
