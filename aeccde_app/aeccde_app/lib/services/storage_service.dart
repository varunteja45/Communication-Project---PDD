import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/session_model.dart';
import '../models/user_model.dart';

/// Local persistence layer backed by SQLite (`sqflite`). All user accounts
/// and practice-session history live entirely on-device inside SQLite.
class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  Database? _db;
  String _activeUserId = 'guest_user';
  List<SessionModel> _cachedSessions = [];

  Database get db {
    if (_db == null) {
      throw StateError('StorageService is not initialized. Call init() first.');
    }
    return _db!;
  }

  String get activeUserId => _activeUserId;

  Future<void> init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'aeccde_database.db');

    _db = await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await _createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await _createTables(db);
      },
    );

    // Double check table existence for safety
    await _db!.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id TEXT PRIMARY KEY,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        name TEXT NOT NULL,
        ageRange TEXT,
        occupation TEXT,
        language TEXT,
        level TEXT,
        goals TEXT,
        createdAt TEXT NOT NULL
      )
    ''');

    await _db!.execute('''
      CREATE TABLE IF NOT EXISTS active_session (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        userId TEXT NOT NULL
      )
    ''');

    await _db!.execute('''
      CREATE TABLE IF NOT EXISTS sessions (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL DEFAULT 'guest_user',
        environmentId TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        transcript TEXT NOT NULL,
        overallScore REAL NOT NULL,
        fluencyScore REAL NOT NULL,
        vocabularyScore REAL NOT NULL,
        grammarScore REAL NOT NULL,
        paceScore REAL NOT NULL,
        confidenceScore REAL NOT NULL,
        clarityScore REAL NOT NULL,
        wordCount INTEGER NOT NULL,
        fillerCount INTEGER NOT NULL,
        durationSeconds INTEGER NOT NULL,
        wordsPerMinute REAL NOT NULL,
        strengths TEXT NOT NULL,
        improvements TEXT NOT NULL,
        questionEvaluations TEXT
      )
    ''');

    try {
      await _db!.execute('ALTER TABLE sessions ADD COLUMN questionEvaluations TEXT');
    } catch (_) {}

    final activeId = await getActiveUserId();
    _activeUserId = activeId ?? 'guest_user';
    await reloadCacheForUser(_activeUserId);
  }

  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id TEXT PRIMARY KEY,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        name TEXT NOT NULL,
        ageRange TEXT,
        occupation TEXT,
        language TEXT,
        level TEXT,
        goals TEXT,
        createdAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS active_session (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        userId TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS sessions (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL DEFAULT 'guest_user',
        environmentId TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        transcript TEXT NOT NULL,
        overallScore REAL NOT NULL,
        fluencyScore REAL NOT NULL,
        vocabularyScore REAL NOT NULL,
        grammarScore REAL NOT NULL,
        paceScore REAL NOT NULL,
        confidenceScore REAL NOT NULL,
        clarityScore REAL NOT NULL,
        wordCount INTEGER NOT NULL,
        fillerCount INTEGER NOT NULL,
        durationSeconds INTEGER NOT NULL,
        wordsPerMinute REAL NOT NULL,
        strengths TEXT NOT NULL,
        improvements TEXT NOT NULL
      )
    ''');
  }

  // ---------------------------------------------------------------------
  // User Authentication & Profile Persistence
  // ---------------------------------------------------------------------

  Future<void> saveUser(UserModel user) async {
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    if (kDebugMode) {
      print('DEBUG [StorageService] Saved user: ${user.email} (${user.name})');
    }
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final cleanEmail = email.toLowerCase().trim();
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'LOWER(email) = ?',
      whereArgs: [cleanEmail],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }

    // In-memory fallback search across all users to guarantee match
    final List<Map<String, dynamic>> allUsers = await db.query('users');
    for (final map in allUsers) {
      final storedEmail = (map['email'] as String? ?? '').toLowerCase().trim();
      if (storedEmail == cleanEmail) {
        return UserModel.fromMap(map);
      }
    }

    return null;
  }

  Future<UserModel?> getUserById(String id) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return UserModel.fromMap(maps.first);
  }

  Future<void> setActiveUserId(String userId) async {
    _activeUserId = userId;
    await db.insert(
      'active_session',
      {'id': 1, 'userId': userId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await reloadCacheForUser(userId);
  }

  Future<String?> getActiveUserId() async {
    final List<Map<String, dynamic>> maps = await db.query('active_session', where: 'id = 1');
    if (maps.isEmpty) return null;
    return maps.first['userId'] as String?;
  }

  // ---------------------------------------------------------------------
  // Per-User Isolated Practice Session Storage
  // ---------------------------------------------------------------------

  Future<void> reloadCacheForUser(String userId) async {
    _activeUserId = userId;
    if (_db == null) return;
    final List<Map<String, dynamic>> maps = await db.query(
      'sessions',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'timestamp DESC',
    );
    _cachedSessions = maps.map((map) => SessionModel.fromMap(map)).toList();
  }

  Future<void> saveSession(SessionModel session) async {
    final userSession = SessionModel(
      id: session.id,
      userId: _activeUserId,
      environmentId: session.environmentId,
      timestamp: session.timestamp,
      transcript: session.transcript,
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
      strengths: session.strengths,
      improvements: session.improvements,
    );

    await db.insert(
      'sessions',
      userSession.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await reloadCacheForUser(_activeUserId);
  }

  List<SessionModel> getAllSessions() {
    return List.unmodifiable(_cachedSessions);
  }

  List<SessionModel> getSessionsForEnvironment(String environmentId) {
    return _cachedSessions.where((s) => s.environmentId == environmentId).toList();
  }

  Future<void> deleteSession(String id) async {
    await db.delete(
      'sessions',
      where: 'id = ? AND userId = ?',
      whereArgs: [id, _activeUserId],
    );
    await reloadCacheForUser(_activeUserId);
  }

  Future<void> clearAll() async {
    await db.delete(
      'sessions',
      where: 'userId = ?',
      whereArgs: [_activeUserId],
    );
    await reloadCacheForUser(_activeUserId);
  }

  double get averageOverallScore {
    if (_cachedSessions.isEmpty) return 0;
    final sum = _cachedSessions.fold<double>(0, (acc, s) => acc + s.overallScore);
    return sum / _cachedSessions.length;
  }

  int get totalSessions => _cachedSessions.length;

  Map<String, double> get bestCompetencyAverages {
    if (_cachedSessions.isEmpty) {
      return {
        'Fluency': 0,
        'Vocabulary': 0,
        'Grammar': 0,
        'Pace': 0,
        'Confidence': 0,
        'Clarity': 0,
      };
    }
    double f = 0, v = 0, g = 0, p = 0, c = 0, cl = 0;
    for (final s in _cachedSessions) {
      f += s.fluencyScore;
      v += s.vocabularyScore;
      g += s.grammarScore;
      p += s.paceScore;
      c += s.confidenceScore;
      cl += s.clarityScore;
    }
    final n = _cachedSessions.length;
    return {
      'Fluency': f / n,
      'Vocabulary': v / n,
      'Grammar': g / n,
      'Pace': p / n,
      'Confidence': c / n,
      'Clarity': cl / n,
    };
  }
}
