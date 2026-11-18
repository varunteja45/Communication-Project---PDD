import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/session_model.dart';
import '../models/user_model.dart';
import 'storage_service.dart';

/// Handles bi-directional real-time data synchronization & authentication
/// between the Flutter Mobile App's local SQLite database and the Web Server (`http://localhost:3000`).
class SyncService {
  SyncService._();
  static final SyncService instance = SyncService._();

  static const List<String> _possibleServerUrls = [
    'http://localhost:3000',
    'http://10.0.2.2:3000',
    'http://127.0.0.1:3000',
  ];

  String _activeServerUrl = 'http://localhost:3000';

  Future<String> get activeServerUrl async {
    for (final url in _possibleServerUrls) {
      try {
        final res = await http.get(Uri.parse('$url/api/active-user')).timeout(const Duration(milliseconds: 600));
        if (res.statusCode == 200) {
          _activeServerUrl = url;
          return _activeServerUrl;
        }
      } catch (_) {}
    }
    return _activeServerUrl;
  }

  /// Pushes a newly created user account to the Web Server.
  Future<bool> syncUser(UserModel user) async {
    try {
      final baseUrl = await activeServerUrl;
      final res = await http.post(
        Uri.parse('$baseUrl/api/users/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': user.id,
          'email': user.email,
          'password': user.password,
          'name': user.name,
        }),
      );

      await http.post(
        Uri.parse('$baseUrl/api/active-user'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': user.id}),
      );

      return res.statusCode == 200;
    } catch (e) {
      debugPrint('[SyncService] User sync error: $e');
      return false;
    }
  }

  /// Authenticates credentials against the Web Server database.
  /// If valid, returns reconstructed [UserModel].
  Future<UserModel?> remoteSignIn({
    required String email,
    required String password,
  }) async {
    try {
      final baseUrl = await activeServerUrl;
      final res = await http.post(
        Uri.parse('$baseUrl/api/users/signin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (res.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(res.body) as Map<String, dynamic>;
        if (data['success'] == true && data['user'] != null) {
          final Map<String, dynamic> userMap = data['user'] as Map<String, dynamic>;
          return UserModel(
            id: userMap['id'] as String,
            email: userMap['email'] as String,
            password: userMap['password'] as String,
            name: userMap['name'] as String,
            level: userMap['level'] as String? ?? 'Intermediate',
            createdAt: userMap['createdAt'] != null
                ? DateTime.parse(userMap['createdAt'] as String)
                : DateTime.now(),
          );
        }
      }
    } catch (e) {
      debugPrint('[SyncService] Remote signin error: $e');
    }
    return null;
  }

  /// Pushes a completed evaluation session to the Web Server.
  Future<void> syncSession(SessionModel session) async {
    try {
      final baseUrl = await activeServerUrl;
      await http.post(
        Uri.parse('$baseUrl/api/sessions'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(session.toMap()),
      );
    } catch (e) {
      debugPrint('[SyncService] Session sync error: $e');
    }
  }

  /// Pulls the latest session records from Web Server and merges into local SQLite.
  Future<void> pullSessions(String userId) async {
    try {
      final baseUrl = await activeServerUrl;
      final res = await http.get(Uri.parse('$baseUrl/api/sessions?userId=$userId'));
      if (res.statusCode == 200) {
        final List parsed = jsonDecode(res.body) as List;
        for (final item in parsed) {
          try {
            final session = SessionModel.fromMap(item as Map<String, dynamic>);
            await StorageService.instance.saveSession(session);
          } catch (_) {}
        }
      }
    } catch (e) {
      debugPrint('[SyncService] Pull sessions error: $e');
    }
  }
}
