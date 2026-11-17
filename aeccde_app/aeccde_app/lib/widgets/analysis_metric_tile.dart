import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class AnalysisMetricTile extends StatelessWidget {
  final String label;
  final String value;
  final double progress;
  final String? badgeText;
  final Color? badgeColor;
  final IconData? icon;
  final bool showBadge;
  final bool darkTheme;

  const AnalysisMetricTile({
    super.key,
    required this.label,
    required this.value,
    required this.progress,
    this.badgeText,
    this.badgeColor,
    this.icon,
    this.showBadge = false,
    this.darkTheme = true,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = darkTheme ? const Color(0xFF1E1C40) : Colors.white;
    final textColor = darkTheme ? Colors.white : const Color(0xFF1A1A1A);
    final secondaryTextColor = darkTheme ? Colors.white70 : Colors.grey.shade600;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: darkTheme ? Colors.white10 : Colors.grey.shade100),
        boxShadow: [
          if (!darkTheme)
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: const Color(0xFF534AE3)),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (showBadge && badgeText != null) ...[
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (badgeColor ?? Colors.green).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: (badgeColor ?? Colors.green).withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (badgeColor != null)
                        Icon(
                          badgeText!.toLowerCase().contains('reduce') ? Icons.warning_amber_rounded : Icons.check_rounded,
                          size: 12,
                          color: badgeColor,
                        ),
                      if (badgeColor != null) const SizedBox(width: 4),
                      Text(
                        badgeText!,
                        style: TextStyle(
                          color: badgeColor ?? Colors.green,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          LinearPercentIndicator(
            lineHeight: 6,
            percent: progress.clamp(0.0, 1.0),
            backgroundColor: darkTheme ? Colors.white10 : Colors.grey.shade100,
            progressColor: _getProgressColor(),
            barRadius: const Radius.circular(3),
            padding: EdgeInsets.zero,
            animation: true,
          ),
        ],
      ),
    );
  }

  Color _getProgressColor() {
    if (label.toLowerCase().contains('filler')) return Colors.orange;
    if (label.toLowerCase().contains('nervous')) return Colors.orange;
    if (label.toLowerCase().contains('fluency')) return const Color(0xFF7A6FFF);
    if (label.toLowerCase().contains('confidence')) return const Color(0xFF534AE3);
    if (label.toLowerCase().contains('calmness')) return Colors.cyan;
    if (label.toLowerCase().contains('engagement')) return Colors.green;
    return const Color(0xFF00BFA5);
  }
}
