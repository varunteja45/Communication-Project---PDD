import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import '../models/evaluation_result.dart';

class StrengthsScreen extends StatelessWidget {
  final EvaluationResult? result;

  const StrengthsScreen({super.key, this.result});

  @override
  Widget build(BuildContext context) {
    final strengths = result?.strengths ?? [
      'Strong Phonetic Accuracy',
      'Good Vocabulary Diversity',
      'Clear Vocal Delivery',
      'Consistent Pacing',
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
          'Your Strengths',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 32),
            
            // Header Section
            FadeInDown(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFF9E6),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text('⭐', style: TextStyle(fontSize: 40)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Communication Strengths',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Key competencies where you excel',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Strengths List
            ...strengths.map((str) => _buildStrengthCard(
                  str,
                  'Demonstrated solid execution during your practice session.',
                  Icons.check_circle_rounded,
                  const Color(0xFF00BFA5),
                )),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStrengthCard(String title, String description, IconData icon, Color color) {
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500, height: 1.4),
                  ),
                ],
              ),
            ),
            const Icon(Icons.check_rounded, color: Color(0xFF00BFA5), size: 20),
          ],
        ),
      ),
    );
  }
}
