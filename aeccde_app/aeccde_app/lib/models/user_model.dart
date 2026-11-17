import 'dart:convert';

/// Data model representing an authenticated AECCDE user account.
class UserModel {
  final String id;
  final String email;
  final String password;
  final String name;
  final String ageRange;
  final String occupation;
  final String language;
  final String level;
  final List<String> goals;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.password,
    required this.name,
    this.ageRange = '18 - 24',
    this.occupation = 'Student',
    this.language = 'English',
    this.level = 'Intermediate',
    this.goals = const [],
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email.toLowerCase().trim(),
      'password': password,
      'name': name,
      'ageRange': ageRange,
      'occupation': occupation,
      'language': language,
      'level': level,
      'goals': jsonEncode(goals),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      name: map['name'] as String,
      ageRange: map['ageRange'] as String? ?? '18 - 24',
      occupation: map['occupation'] as String? ?? 'Student',
      language: map['language'] as String? ?? 'English',
      level: map['level'] as String? ?? 'Intermediate',
      goals: map['goals'] != null
          ? List<String>.from(jsonDecode(map['goals'] as String) as List)
          : [],
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  UserModel copyWith({
    String? name,
    String? ageRange,
    String? occupation,
    String? language,
    String? level,
    List<String>? goals,
  }) {
    return UserModel(
      id: id,
      email: email,
      password: password,
      name: name ?? this.name,
      ageRange: ageRange ?? this.ageRange,
      occupation: occupation ?? this.occupation,
      language: language ?? this.language,
      level: level ?? this.level,
      goals: goals ?? this.goals,
      createdAt: createdAt,
    );
  }
}
