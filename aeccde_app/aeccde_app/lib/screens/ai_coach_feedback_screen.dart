import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import '../models/evaluation_result.dart';
import 'seven_day_plan_screen.dart';
import 'ai_coach_chat_screen.dart';

class AiCoachFeedbackScreen extends StatelessWidget {
  final EvaluationResult? result;

  const AiCoachFeedbackScreen({super.key, this.result});

  @override
  Widget build(BuildContext context) {
    final strengths = result?.strengths ?? [
      'Pronunciation accuracy of ${(result?.clarityScore ?? 88).round()}%',
      'Consistent speaking pace of ${(result?.wordsPerMinute ?? 138).round()} WPM',
      'Clear topic relevance and vocabulary usage',
    ];

    final improvements = result?.improvements ?? [
      'Recorded ${result?.fillerCount ?? 3} filler words during session',
      'Refine subject-verb agreement in complex sentences',
      'Enhance pause techniques to build vocal authority',
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
          'AI Coach Feedback',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 16),
            
            // AI Coach Header Card
            FadeInDown(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AiCoachChatScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF534AE3), Color(0xFF7A6FFF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          const CircleAvatar(
                            radius: 36,
                            backgroundColor: Colors.white24,
                            child: Text('🤖', style: TextStyle(fontSize: 32)),
                          ),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(color: Color(0xFF00BFA5), shape: BoxShape.circle),
                            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 12),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your AI Communication Coach',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Tap here to chat with your AI Coach live',
                              style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.4),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // What You Did Well
            _buildFeedbackList(
              title: 'What You Did Well',
              icon: Icons.check_circle_rounded,
              color: const Color(0xFF00BFA5),
              bgColor: const Color(0xFFF1F8F1),
              items: strengths,
            ),
            
            const SizedBox(height: 20),
            
            // What Needs Improvement
            _buildFeedbackList(
              title: 'What Needs Improvement',
              icon: Icons.warning_rounded,
              color: const Color(0xFFF9A825),
              bgColor: const Color(0xFFFFF9E6),
              items: improvements,
            ),
            
            const SizedBox(height: 28),
            
            // Bottom Action
            FadeInUp(
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SevenDayPlanScreen(result: result)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF534AE3),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('View 7-Day Plan', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(width: 8),
                      Icon(Icons.calendar_today_rounded, size: 18, color: Colors.white),
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

  Widget _buildFeedbackList({required String title, required IconData icon, required Color color, required Color bgColor, required List<String> items}) {
    return FadeInUp(
      child: Container(
        padding: const EdgeInsets.all(24),
        width: double.infinity,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 12),
                Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 16),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• ', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(color: Colors.grey.shade800, fontSize: 14, height: 1.5),
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
