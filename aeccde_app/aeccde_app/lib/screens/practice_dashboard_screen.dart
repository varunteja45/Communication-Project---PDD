import 'package:flutter/material.dart';
import 'speaking_practice_screen.dart';
import 'pronunciation_practice_screen.dart';
import 'fluency_practice_screen.dart';
import 'grammar_practice_screen.dart';
import 'vocabulary_practice_screen.dart';
import 'confidence_practice_screen.dart';
import 'achievements_screen.dart';

class PracticeDashboardScreen extends StatelessWidget {
  const PracticeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF534AE3), Color(0xFF7A6FFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Practice',
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sharpen your communication skills',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const AchievementsScreen()));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.emoji_events_rounded, color: Colors.amber, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'View Achievements',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  
                  // Streak Card
                  _buildStreakCard(),
                  
                  const SizedBox(height: 24),
                  
                  const Text(
                    '✨ Recommended for You',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const GrammarPracticeScreen()));
                    },
                    child: _buildRecommendationCard(),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  const Text(
                    'All Practice Types',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
                  ),
                  const SizedBox(height: 12),
                  
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.78,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SpeakingPracticeScreen())),
                        child: _buildPracticeTypeCard('Speaking\nPractice', 'Freestyle speaking', 'Intermediate', Icons.mic_rounded, const Color(0xFF534AE3)),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PronunciationPracticeScreen())),
                        child: _buildPracticeTypeCard('Pronunciation\nPractice', 'AI phonetic coaching', 'Beginner', Icons.abc_rounded, const Color(0xFF00ACC1)),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FluencyPracticeScreen())),
                        child: _buildPracticeTypeCard('Fluency\nPractice', 'Reduce filler words', 'Intermediate', Icons.bolt_rounded, const Color(0xFF00BFA5)),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GrammarPracticeScreen())),
                        child: _buildPracticeTypeCard('Grammar\nPractice', 'Correct sentence errors', 'Beginner', Icons.edit_note_rounded, const Color(0xFF9C27B0)),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VocabularyPracticeScreen())),
                        child: _buildPracticeTypeCard('Vocabulary\nPractice', 'Expand word bank', 'Advanced', Icons.menu_book_rounded, const Color(0xFFFF9100)),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ConfidencePracticeScreen())),
                        child: _buildPracticeTypeCard('Confidence\nPractice', 'Speak with authority', 'Advanced', Icons.fitness_center_rounded, const Color(0xFFE91E63)),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: Color(0xFFFFF9E6), shape: BoxShape.circle),
            child: const Text('🔥', style: TextStyle(fontSize: 28)),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Current Streak', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
                SizedBox(height: 2),
                Text('5 Days', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('Best: 12 days', style: TextStyle(color: Colors.grey, fontSize: 11)),
              const SizedBox(height: 6),
              Row(
                children: List.generate(5, (i) => Icon(Icons.circle, size: 8, color: i < 4 ? Colors.orange : Colors.grey.shade200)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF534AE3), Color(0xFF7A6FFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(14)),
            child: const Icon(Icons.edit_note_rounded, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Grammar Practice', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                SizedBox(height: 2),
                Text('Based on your last evaluation', style: TextStyle(color: Colors.white70, fontSize: 11)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(10)),
            child: const Text('Practice →', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
          ),
        ],
      ),
    );
  }

  Widget _buildPracticeTypeCard(String title, String subtitle, String level, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 8),
          Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, height: 1.2)),
          const SizedBox(height: 4),
          Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey.shade500, fontSize: 10)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: level == 'Beginner' ? const Color(0xFFF1F8F1) : const Color(0xFFF0F2FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              level,
              style: TextStyle(
                color: level == 'Beginner' ? const Color(0xFF00BFA5) : const Color(0xFF534AE3),
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
