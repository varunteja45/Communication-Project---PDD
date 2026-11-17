import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class PronunciationAnalysisScreen extends StatelessWidget {
  const PronunciationAnalysisScreen({super.key});

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
          'Pronunciation Analysis',
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
                        children: const [
                          Text('88', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                          Text('Accuracy', style: TextStyle(color: Colors.white70, fontSize: 8)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Pronunciation Accuracy', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('88%', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('17 of 20 words correct', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Waveform Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FF),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Speech Waveform', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(20, (i) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            width: 3,
                            height: 10 + (i % 4 * 10),
                            decoration: BoxDecoration(color: const Color(0xFF7A6FFF).withOpacity(0.3), borderRadius: BorderRadius.circular(2)),
                          )),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(20, (i) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            width: 3,
                            height: 8 + (i % 3 * 8),
                            decoration: BoxDecoration(color: const Color(0xFF00ACC1), borderRadius: BorderRadius.circular(2)),
                          )),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLegendItem('Reference', Colors.grey.shade400),
                      const SizedBox(width: 16),
                      _buildLegendItem('Your pronunciation', const Color(0xFF00ACC1)),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            const Text('Word Analysis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            _buildWordCard('Communication', 'Kuh-myoo-ni-KAY-shun', false),
            _buildWordCard('Pronunciation', 'Pro-NUN-see-AY-shun', true),
            _buildWordCard('Professional', 'Pro-FESH-un-ul', true),
            _buildWordCard('Opportunity', 'Op-por-TOO-ni-tee', false),
            _buildWordCard('Articulate', 'Ar-TIC-yoo-layt', true),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.rectangle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildWordCard(String word, String phonetic, bool isCorrect) {
    return FadeInUp(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isCorrect ? const Color(0xFFF1F8F1) : const Color(0xFFFFF9E6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isCorrect ? const Color(0xFFE8F5E9) : const Color(0xFFFFF1CC)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(word, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(phonetic, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
              ],
            ),
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
                    isCorrect ? 'Correct' : 'Needs Practice',
                    style: TextStyle(color: isCorrect ? Colors.green : Colors.orange, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
