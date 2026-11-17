import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import 'overall_report_screen.dart';
import 'areas_to_improve_screen.dart';

class EvaluationCompletedScreen extends StatelessWidget {
  const EvaluationCompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 30),
              
              // Confetti Icon
              FadeInDown(
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F5E9),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('🎉', style: TextStyle(fontSize: 60)),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              const Text(
                'Evaluation Completed!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                'Great job! Your AI-powered communication\nanalysis is ready.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade500,
                  height: 1.4,
                ),
              ),
              
              const SizedBox(height: 28),
              
              // Stats Row
              Row(
                children: [
                  _buildStatBox('82', 'Overall\nScore', const Color(0xFFF0F2FF), const Color(0xFF534AE3)),
                  const SizedBox(width: 12),
                  _buildStatBox('4:32', 'Duration', const Color(0xFFF9F0FF), const Color(0xFF7A6FFF)),
                  const SizedBox(width: 12),
                  _buildStatBox('↑ +7', 'Improvement', const Color(0xFFF1F8F1), const Color(0xFF00BFA5)),
                ],
              ),
              
              const SizedBox(height: 24),
              
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    '"Excellent effort! Your fluency and pronunciation show great improvement. Keep practicing!"',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Buttons
              FadeInUp(
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const OverallReportScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF534AE3),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        child: const Text(
                          'View Full Report',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AreasToImproveScreen()),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFE0E4FF)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text(
                          'Practice Weak Areas',
                          style: TextStyle(color: Color(0xFF534AE3), fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                      child: Text(
                        'Return Home',
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatBox(String value, String label, Color bgColor, Color textColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: textColor.withOpacity(0.6)),
            ),
          ],
        ),
      ),
    );
  }
}
