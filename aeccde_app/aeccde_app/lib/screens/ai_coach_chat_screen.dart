import 'package:flutter/material.dart';

class AiCoachChatScreen extends StatefulWidget {
  const AiCoachChatScreen({super.key});

  @override
  State<AiCoachChatScreen> createState() => _AiCoachChatScreenState();
}

class _AiCoachChatScreenState extends State<AiCoachChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'isUser': false,
      'text':
          "Hello! I'm your AI Communication Coach. I've analyzed your recent evaluation and I'm ready to help you improve. Ask me anything about your communication skills!",
      'time': 'Just now',
    },
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    final clean = text.trim();
    if (clean.isEmpty) return;

    setState(() {
      _messages.add({
        'isUser': true,
        'text': clean,
        'time': 'Just now',
      });
      _controller.clear();
    });

    // Simulate intelligent AI Coach response
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      String response = "Great question! Practice speaking aloud for 1-2 minutes daily and focus on pausing silently instead of using filler words. Steady rhythm creates instant authority.";
      
      final lower = clean.toLowerCase();
      if (lower.contains('fluency')) {
        response = "To boost fluency, try the '60-Second Non-Stop Challenge' in the Practice Dashboard. Focus on maintaining a steady flow of 120-150 words per minute without long pauses.";
      } else if (lower.contains('filler') || lower.contains('um') || lower.contains('like')) {
        response = "Filler words like 'um' and 'like' usually happen when your brain seeks time to think. Practice embracing brief 1-second silent pauses — it makes you sound far more composed!";
      } else if (lower.contains('grammar')) {
        response = "For grammar, focus on subject-verb agreement and keeping sentences between 8 to 20 words. Try our interactive Grammar Practice module in the Practice section.";
      } else if (lower.contains('confidence')) {
        response = "Confidence comes from posture, eye contact, and vocal modulation. Maintain a strong posture and speak with a calm, deliberate tone.";
      }

      setState(() {
        _messages.add({
          'isUser': false,
          'text': response,
          'time': 'Just now',
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF534AE3),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white24,
                  child: Text('🤖', style: TextStyle(fontSize: 18)),
                ),
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00BFA5),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF534AE3), width: 1.5),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('AI Communication Coach', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                Text('Online', style: TextStyle(color: Colors.white60, fontSize: 11)),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['isUser'] as bool;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isUser) ...[
                        const CircleAvatar(
                          radius: 16,
                          backgroundColor: Color(0xFFF0F2FF),
                          child: Text('🤖', style: TextStyle(fontSize: 14)),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: isUser ? const Color(0xFF534AE3) : const Color(0xFFF8F9FF),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(20),
                              topRight: const Radius.circular(20),
                              bottomLeft: isUser ? const Radius.circular(20) : Radius.zero,
                              bottomRight: isUser ? Radius.zero : const Radius.circular(20),
                            ),
                            border: isUser ? null : Border.all(color: const Color(0xFFE0E4FF)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                msg['text'] as String,
                                style: TextStyle(
                                  color: isUser ? Colors.white : const Color(0xFF1A1A1A),
                                  fontSize: 14,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                msg['time'] as String,
                                style: TextStyle(
                                  color: isUser ? Colors.white60 : Colors.grey,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isUser) ...[
                        const SizedBox(width: 12),
                        const CircleAvatar(
                          radius: 16,
                          backgroundColor: Color(0xFF4FC3F7),
                          child: Text('AK', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
          
          // Action Bar & Input
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
            ),
            child: Column(
              children: [
                // Suggestion chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildSuggestionChip('How can I improve my fluency?'),
                      _buildSuggestionChip('How to reduce fillers?'),
                      _buildSuggestionChip('Tips for confidence?'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(color: Color(0xFFF5F5F5), shape: BoxShape.circle),
                      child: const Icon(Icons.mic_none_rounded, color: Colors.grey, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextField(
                          controller: _controller,
                          onSubmitted: _sendMessage,
                          decoration: const InputDecoration(
                            hintText: 'Ask your AI coach...',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => _sendMessage(_controller.text),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(color: Color(0xFF534AE3), shape: BoxShape.circle),
                        child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String label) {
    return GestureDetector(
      onTap: () => _sendMessage(label),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F2FF),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE0E4FF)),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Color(0xFF534AE3), fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
