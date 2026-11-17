import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'overall_report_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

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
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Mark all read',
              style: TextStyle(
                color: Color(0xFF7A6FFF),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          FadeInUp(
            duration: const Duration(milliseconds: 400),
            child: _NotificationItem(
              title: 'AI Report Ready',
              subtitle: 'Your Interview evaluation report is ready to view.',
              time: '2 min ago',
              icon: Icons.bar_chart_rounded,
              iconColor: Colors.blue,
              isRead: false,
              highlighted: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OverallReportScreen(),
                  ),
                );
              },
            ),
          ),
          FadeInUp(
            duration: const Duration(milliseconds: 400),
            delay: const Duration(milliseconds: 100),
            child: const _NotificationItem(
              title: 'Practice Reminder',
              subtitle: "Keep your practice streak active today!",
              time: '1 hour ago',
              icon: Icons.alarm_rounded,
              iconColor: Colors.pinkAccent,
              isRead: false,
              highlighted: true,
            ),
          ),
          FadeInUp(
            duration: const Duration(milliseconds: 400),
            delay: const Duration(milliseconds: 200),
            child: const _NotificationItem(
              title: 'Weekly Progress',
              subtitle: 'Your overall score improved by 7 points this week.',
              time: '2 hours ago',
              icon: Icons.show_chart_rounded,
              iconColor: Colors.blueAccent,
              isRead: false,
              highlighted: true,
            ),
          ),
          FadeInUp(
            duration: const Duration(milliseconds: 400),
            delay: const Duration(milliseconds: 300),
            child: const _NotificationItem(
              title: 'Achievement Unlocked!',
              subtitle: 'You earned the "Fluency Master" badge!',
              time: 'Yesterday',
              icon: Icons.emoji_events_rounded,
              iconColor: Colors.orange,
              isRead: true,
            ),
          ),
          FadeInUp(
            duration: const Duration(milliseconds: 400),
            delay: const Duration(milliseconds: 400),
            child: const _NotificationItem(
              title: 'AI Suggestion',
              subtitle: 'Try Confidence Practice to improve your delivery.',
              time: '2 days ago',
              icon: Icons.lightbulb_outline_rounded,
              iconColor: Colors.amber,
              isRead: true,
            ),
          ),
          FadeInUp(
            duration: const Duration(milliseconds: 400),
            delay: const Duration(milliseconds: 500),
            child: const _NotificationItem(
              title: 'New Feature Available',
              subtitle: 'Group Discussion evaluation mode is ready.',
              time: '3 days ago',
              icon: Icons.notifications_active_rounded,
              iconColor: Colors.deepOrangeAccent,
              isRead: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color iconColor;
  final bool isRead;
  final bool highlighted;
  final VoidCallback? onTap;

  const _NotificationItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.iconColor,
    this.isRead = true,
    this.highlighted = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: highlighted ? const Color(0xFFF0F2FF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: highlighted ? const Color(0xFFE0E4FF) : Colors.grey.shade100,
          ),
          boxShadow: [
            if (!highlighted)
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                        ),
                        if (!isRead) ...[
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF534AE3),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
