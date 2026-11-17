import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          'Achievements',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20, top: 12, bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F2FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Text(
                '4 / 7',
                style: TextStyle(color: Color(0xFF534AE3), fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            
            // Earned Section
            _buildSectionHeader('🎖️ Earned (4)'),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: [
                _buildAchievementCard('First Evaluation', 'Completed your first session', '🎖️', true),
                _buildAchievementCard('7-Day Streak', 'Practiced 7 days in a row', '🔥', true),
                _buildAchievementCard('Fluency Master', 'Scored 84+ in fluency', '⚡', true),
                _buildAchievementCard('Pronunciation Pro', 'Scored 88+ in pronunciation', 'abc', true, isAbcIcon: true),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // In Progress Section
            _buildSectionHeader('🔒 In Progress (3)'),
            const SizedBox(height: 16),
            _buildInProgressCard('Confident Speaker', 'Score 90+ in confidence', 0.8),
            _buildInProgressCard('10 Evaluations', 'Complete 10 evaluations', 0.6),
            _buildInProgressCard('Consistent Performer', 'Improve for 4 weeks straight', 0.5),
            
            const SizedBox(height: 32),
            
            // Footer
            FadeInUp(
              child: Container(
                padding: const EdgeInsets.all(24),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F2FF),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Center(
                  child: Text(
                    'Keep going!',
                    style: TextStyle(color: Color(0xFF534AE3), fontSize: 16, fontWeight: FontWeight.bold),
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

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
    );
  }

  Widget _buildAchievementCard(String title, String subtitle, String icon, bool earned, {bool isAbcIcon = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: earned ? const Color(0xFFFFF9F0) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: earned ? const Color(0xFFFFE0B2) : Colors.grey.shade100),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
            ),
            child: isAbcIcon 
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(color: const Color(0xFF2196F3), borderRadius: BorderRadius.circular(4)),
                  child: const Text('abc', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                )
              : Text(icon, style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildInProgressCard(String title, String subtitle, double progress) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(16)),
            child: Icon(Icons.lock_rounded, color: Colors.orange.shade200, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
                const SizedBox(height: 12),
                LinearPercentIndicator(
                  lineHeight: 6,
                  percent: progress,
                  backgroundColor: Colors.grey.shade50,
                  progressColor: Colors.grey.shade300,
                  barRadius: const Radius.circular(3),
                  padding: EdgeInsets.zero,
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.center,
                  child: Text('${(progress * 100).toInt()}%', style: TextStyle(fontSize: 10, color: Colors.grey.shade400, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
