import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/user_model.dart';
import '../services/storage_service.dart';
import '../services/sync_service.dart';

/// Manages authentication state, active logged-in user profile,
/// per-user data loading, and bi-directional real-time sync.
class UserProvider extends ChangeNotifier {
  final StorageService _storage = StorageService.instance;
  final SyncService _sync = SyncService.instance;
  final Uuid _uuid = const Uuid();

  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;

  String get displayName => _currentUser?.name ?? 'Guest User';
  String get userEmail => _currentUser?.email ?? 'guest@aeccde.app';

  UserProvider() {
    _initUser();
  }

  Future<void> _initUser() async {
    _isLoading = true;
    notifyListeners();

    final activeId = await _storage.getActiveUserId();
    if (activeId != null && activeId != 'guest_user') {
      _currentUser = await _storage.getUserById(activeId);
      if (_currentUser != null) {
        _sync.syncUser(_currentUser!);
        _sync.pullSessions(_currentUser!.id);
      }
    }
    
    _isLoading = false;
    notifyListeners();
  }

  /// Sign Up a new user into SQLite database with password complexity checks and web sync.
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final cleanEmail = email.toLowerCase().trim();
      final cleanPassword = password.trim();
      final cleanName = name.trim();

      if (cleanPassword.length < 5 ||
          !RegExp(r'[a-z]').hasMatch(cleanPassword) ||
          !RegExp(r'[A-Z]').hasMatch(cleanPassword) ||
          !RegExp(r'[0-9]').hasMatch(cleanPassword) ||
          !RegExp(r'[^a-zA-Z0-9]').hasMatch(cleanPassword)) {
        throw Exception(
            'Password must contain at least 5 characters, including uppercase, lowercase, numbers, and special symbols.');
      }

      final existing = await _storage.getUserByEmail(cleanEmail);
      if (existing != null) {
        throw Exception('An account with this email address already exists.');
      }

      final newUser = UserModel(
        id: _uuid.v4(),
        email: cleanEmail,
        password: cleanPassword,
        name: cleanName,
        createdAt: DateTime.now(),
      );

      await _storage.saveUser(newUser);
      _sync.syncUser(newUser);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sign In an existing user from SQLite database (checking local SQLite & Web Server database).
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final cleanEmail = email.toLowerCase().trim();
      final cleanPassword = password.trim();

      // 1. Check local phone SQLite first
      var user = await _storage.getUserByEmail(cleanEmail);

      // 2. If not found locally or password mismatch, authenticate against Web Server Database API!
      if (user == null || user.password.trim() != cleanPassword) {
        final remoteUser = await _sync.remoteSignIn(email: cleanEmail, password: cleanPassword);
        if (remoteUser != null) {
          user = remoteUser;
          // Save downloaded user account to local phone SQLite!
          await _storage.saveUser(user);
          // Pull all practice sessions recorded for this user from server into phone SQLite!
          await _sync.pullSessions(user.id);
        }
      }

      if (user == null || user.password.trim() != cleanPassword) {
        throw Exception('Invalid email address or password.');
      }

      await _storage.setActiveUserId(user.id);
      _currentUser = user;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Continue in Guest mode.
  Future<void> signInGuest() async {
    _currentUser = null;
    await _storage.setActiveUserId('guest_user');
    notifyListeners();
  }

  /// Sign Out current user.
  Future<void> signOut() async {
    _currentUser = null;
    await _storage.setActiveUserId('guest_user');
    notifyListeners();
  }

  /// Updates profile information for the active user.
  Future<void> updateProfile({
    String? ageRange,
    String? occupation,
    String? language,
    String? level,
  }) async {
    if (_currentUser == null) return;

    final updated = _currentUser!.copyWith(
      ageRange: ageRange,
      occupation: occupation,
      language: language,
      level: level,
    );

    await _storage.saveUser(updated);
    _currentUser = updated;
    _sync.syncUser(updated);
    notifyListeners();
  }

  /// Updates selected goals for the active user.
  Future<void> updateGoals(List<String> goals) async {
    if (_currentUser == null) return;

    final updated = _currentUser!.copyWith(goals: goals);
    await _storage.saveUser(updated);
    _currentUser = updated;
    _sync.syncUser(updated);
    notifyListeners();
  }
}
