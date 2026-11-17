import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../providers/session_provider.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';
import 'notifications_screen.dart';
import 'choose_environment_screen.dart';
import 'practice_dashboard_screen.dart';
import 'analytics_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final sessionProvider = context.watch<SessionProvider>();
    final userProvider = context.watch<UserProvider>();

    final bool hasData = sessionProvider.history.isNotEmpty;
    final double avgScore = hasData ? sessionProvider.averageScore.roundToDouble() : 0.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Header
              _buildHeader(userProvider),
              const SizedBox(height: 24),
              
              // Overall Score Card
              _buildMainScoreCard(avgScore, hasData),
              const SizedBox(height: 24),
              
              // Action Cards
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ChooseEnvironmentScreen()),
                        );
                      },
                      child: _buildActionCard(
                        title: 'Start Evaluation',
                        subtitle: 'AI-powered analysis',
                        icon: Icons.search_rounded,
                        gradient: const [Color(0xFF534AE3), Color(0xFF7A6FFF)],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const PracticeDashboardScreen()),
                        );
                      },
                      child: _buildActionCard(
                        title: 'Practice Now',
                        subtitle: 'Improve skills',
                        icon: Icons.layers_rounded,
                        gradient: const [Color(0xFF9C27B0), Color(0xFFE91E63)],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // Category Scores
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Category Scores',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AnalyticsScreen()),
                      );
                    },
                    child: const Text('See all', style: TextStyle(color: Color(0xFF534AE3))),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildCategoryScores(sessionProvider, hasData),
              const SizedBox(height: 32),
              
              // Weekly Progress
              const Text(
                'Weekly Progress',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildWeeklyProgressChart(sessionProvider, hasData),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(UserProvider userProvider) {
    final name = userProvider.displayName;
    final initials = name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join('').toUpperCase();

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Good Day',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                  const SizedBox(width: 4),
                  const Text('👋', style: TextStyle(fontSize: 14)),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const NotificationsScreen()),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Stack(
              children: [
                const Icon(Icons.notifications_none_rounded, color: Colors.black54),
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
          },
          child: CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFF4FC3F7),
            child: Text(
              initials.isEmpty ? 'U' : initials,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen()));
          },
          icon: const Icon(Icons.history_rounded, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildMainScoreCard(double avgScore, bool hasData) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E2A6E), Color(0xFF1A174D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          CircularPercentIndicator(
            radius: 50.0,
            lineWidth: 8.0,
            percent: hasData ? (avgScore / 100).clamp(0.0, 1.0) : 0.0,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  hasData ? "${avgScore.toInt()}" : "0",
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Score",
                  style: TextStyle(color: Colors.white54, fontSize: 10),
                ),
              ],
            ),
            circularStrokeCap: CircularStrokeCap.round,
            backgroundColor: Colors.white12,
            progressColor: AppTheme.accentTeal,
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Overall Communication',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      hasData ? '${avgScore.toInt()} / 100' : '0 / 100',
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.accentTeal.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.arrow_upward, color: AppTheme.accentTeal, size: 14),
                          const SizedBox(width: 2),
                          Text(
                            hasData ? '+7 pts' : '0 pts',
                            style: const TextStyle(color: AppTheme.accentTeal, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      hasData ? 'this week' : 'no sessions yet',
                      style: const TextStyle(color: Colors.white38, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: List.generate(10, (i) => Container(
                    margin: const EdgeInsets.only(right: 3),
                    width: 2,
                    height: hasData ? (8.0 + (i % 3 * 4)) : 4.0,
                    decoration: BoxDecoration(
                      color: AppTheme.accentTeal.withOpacity(hasData ? 0.5 : 0.2),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryScores(SessionProvider sessionProvider, bool hasData) {
    final averages = sessionProvider.competencyAverages;
    final categories = [
      {'label': 'Fluency', 'score': hasData ? (averages['Fluency'] ?? 0).round().toString() : '0', 'icon': '⚡', 'color': Colors.orange},
      {'label': 'Grammar', 'score': hasData ? (averages['Grammar'] ?? 0).round().toString() : '0', 'icon': '📝', 'color': Colors.purple},
      {'label': 'Pronunciation', 'score': hasData ? (averages['Clarity'] ?? 0).round().toString() : '0', 'icon': '🗣️', 'color': Colors.blue},
      {'label': 'Confidence', 'score': hasData ? (averages['Confidence'] ?? 0).round().toString() : '0', 'icon': '💪', 'color': Colors.amber},
      {'label': 'Vocabulary', 'score': hasData ? (averages['Vocabulary'] ?? 0).round().toString() : '0', 'icon': '📖', 'color': Colors.teal},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) => Container(
          margin: const EdgeInsets.only(right: 12),
          padding: const EdgeInsets.all(16),
          width: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Column(
            children: [
              Text(cat['icon'] as String, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 12),
              Text(
                cat['score'] as String,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                cat['label'] as String,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
              const SizedBox(height: 8),
              Container(
                height: 3,
                width: 30,
                decoration: BoxDecoration(
                  color: cat['color'] as Color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildWeeklyProgressChart(SessionProvider sessionProvider, bool hasData) {
    final history = sessionProvider.history;
    List<FlSpot> spots = const [
      FlSpot(0, 0),
      FlSpot(1, 0),
      FlSpot(2, 0),
      FlSpot(3, 0),
      FlSpot(4, 0),
      FlSpot(5, 0),
      FlSpot(6, 0),
    ];

    if (hasData) {
      final recent = history.take(7).toList().reversed.toList();
      spots = List.generate(recent.length, (index) {
        return FlSpot(index.toDouble(), recent[index].overallScore);
      });
    }

    return Container(
      height: 200,
      padding: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 10,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.shade100,
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 20,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 10),
                ),
                reservedSize: 28,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                  if (value >= 0 && value < days.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        days[value.toInt()],
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 10),
                      ),
                    );
                  }
                  return const SizedBox();
                },
                reservedSize: 30,
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (spots.length - 1).clamp(1, 6).toDouble(),
          minY: 0,
          maxY: 100,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: const Color(0xFF534AE3),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: hasData,
                getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                  radius: 4,
                  color: const Color(0xFF534AE3),
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF534AE3).withOpacity(0.1),
                    const Color(0xFF534AE3).withOpacity(0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
