import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/environment_model.dart';
import '../models/session_model.dart';
import '../theme/app_theme.dart';

class SessionHistoryTile extends StatelessWidget {
  final SessionModel session;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const SessionHistoryTile({
    super.key,
    required this.session,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final env = EnvironmentModel.byId(session.environmentId);
    final color = AppTheme.scoreColor(session.overallScore);

    return Dismissible(
      key: Key(session.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: AppTheme.accentRed.withOpacity(0.15),
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(Icons.delete_outline, color: AppTheme.accentRed),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleAvatar(
            backgroundColor: env.color.withOpacity(0.15),
            child: Icon(env.icon, color: env.color, size: 20),
          ),
          title: Text(env.name, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(DateFormat('MMM d, y • h:mm a').format(session.timestamp)),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              session.overallScore.toStringAsFixed(0),
              style: TextStyle(color: color, fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ),
    );
  }
}
