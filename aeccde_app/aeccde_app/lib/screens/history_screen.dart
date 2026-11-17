import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';

import '../models/environment_model.dart';
import '../models/evaluation_result.dart';
import '../providers/session_provider.dart';
import '../widgets/session_history_tile.dart';
import 'results_screen.dart';

class HistoryScreen extends StatefulWidget {
  final String? initialEnvironmentFilter;

  const HistoryScreen({super.key, this.initialEnvironmentFilter});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    if (widget.initialEnvironmentFilter != null) {
      _selectedFilter = widget.initialEnvironmentFilter!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessionProvider = context.watch<SessionProvider>();
    final allHistory = sessionProvider.history;

    final filteredHistory = _selectedFilter == 'all'
        ? allHistory
        : allHistory.where((s) => s.environmentId == _selectedFilter).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2E2A6E), Color(0xFF1A174D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(36),
                bottomRight: Radius.circular(36),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Practice History',
                            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Filtered session records per environment',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    if (allHistory.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.delete_sweep_rounded, color: Colors.white70),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Clear History'),
                              content: const Text('Are you sure you want to delete all practice records for your account?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    sessionProvider.clearAllHistory();
                                    Navigator.pop(ctx);
                                  },
                                  child: const Text('Clear All', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Section Environment Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('all', 'All Sections'),
                      _buildFilterChip('interview', 'Interview'),
                      _buildFilterChip('classroom', 'Classroom'),
                      _buildFilterChip('meeting', 'Meeting'),
                      _buildFilterChip('presentation', 'Presentation'),
                      _buildFilterChip('public_speaking', 'Public Speaking'),
                      _buildFilterChip('group_discussion', 'Group Discussion'),
                      _buildFilterChip('conversation', 'Conversation'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: filteredHistory.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF0F2FF),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.history_rounded, size: 48, color: Color(0xFF534AE3)),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            _selectedFilter == 'all'
                                ? 'No Practice History Yet'
                                : 'No Records for ${EnvironmentModel.byId(_selectedFilter).name}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _selectedFilter == 'all'
                                ? 'Complete a practice evaluation to save records under your account.'
                                : 'Start an evaluation in ${EnvironmentModel.byId(_selectedFilter).name} mode to record unique session data.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: filteredHistory.length,
                    itemBuilder: (context, index) {
                      final session = filteredHistory[index];
                      return FadeInUp(
                        duration: const Duration(milliseconds: 300),
                        delay: Duration(milliseconds: index * 40),
                        child: SessionHistoryTile(
                          session: session,
                          onTap: () {
                            final result = EvaluationResult(
                              overallScore: session.overallScore,
                              fluencyScore: session.fluencyScore,
                              vocabularyScore: session.vocabularyScore,
                              grammarScore: session.grammarScore,
                              paceScore: session.paceScore,
                              confidenceScore: session.confidenceScore,
                              clarityScore: session.clarityScore,
                              wordCount: session.wordCount,
                              fillerCount: session.fillerCount,
                              durationSeconds: session.durationSeconds,
                              wordsPerMinute: session.wordsPerMinute,
                              typeTokenRatio: 0.7,
                              transcript: session.transcript,
                              strengths: session.strengths,
                              improvements: session.improvements,
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ResultsScreen(result: result),
                              ),
                            );
                          },
                          onDelete: () {
                            sessionProvider.deleteSession(session.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Session deleted')),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String filterId, String label) {
    final isSelected = _selectedFilter == filterId;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = filterId),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00BFA5) : Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF00BFA5) : Colors.white24,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
