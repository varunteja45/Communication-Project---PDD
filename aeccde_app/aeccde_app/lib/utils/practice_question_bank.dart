import 'dart:math';
import 'package:flutter/material.dart';

/// Centralized repository providing dynamic, non-repeating practice questions
/// across all 6 practice modules (Speaking, Pronunciation, Fluency, Grammar, Vocabulary, Confidence).
class PracticeQuestionBank {
  static final Random _random = Random();

  // ---------------------------------------------------------------------
  // Speaking Practice Topics
  // ---------------------------------------------------------------------
  static const List<String> _speakingTopics = [
    'Explain your favorite technology and why it impacts your daily life.',
    'Describe your dream job and the key skills required to excel in it.',
    'Discuss the pros and cons of remote work versus office collaboration.',
    'Explain how artificial intelligence is changing modern education.',
    'Share a memorable travel experience and what you learned from it.',
    'Discuss the importance of effective time management for students.',
    'Explain why strong communication skills matter in corporate leadership.',
    'Describe a book, movie, or mentor that inspired your personal values.',
    'Discuss the impact of social media on modern interpersonal relationships.',
    'Explain how renewable energy can shape the future of our environment.',
    'Describe a challenge you faced in a group project and how you solved it.',
    'Discuss why lifelong learning is essential in the fast-paced tech industry.',
    'Explain your strategy for maintaining work-life balance under pressure.',
    'Describe how public speaking skills can boost professional confidence.',
    'Discuss the role of ethics and integrity in team decision making.',
  ];

  static String getRandomSpeakingTopic() {
    return _speakingTopics[_random.nextInt(_speakingTopics.length)];
  }

  // ---------------------------------------------------------------------
  // Pronunciation Words
  // ---------------------------------------------------------------------
  static const List<Map<String, String>> _pronunciationWords = [
    {'word': 'Communication', 'phonetic': '/kəˌmju:nɪˈkeɪʃən/'},
    {'word': 'Articulation', 'phonetic': '/ɑ:ˌtɪkjʊˈleɪʃən/'},
    {'word': 'Persuasive', 'phonetic': '/pəˈsweɪsɪv/'},
    {'word': 'Confidence', 'phonetic': '/ˈkɒnfɪdəns/'},
    {'word': 'Meticulous', 'phonetic': '/məˈtɪkjʊləs/'},
    {'word': 'Resilient', 'phonetic': '/rɪˈzɪlɪənt/'},
    {'word': 'Collaboration', 'phonetic': '/kəˌlæbəˈreɪʃən/'},
    {'word': 'Leadership', 'phonetic': '/ˈli:dəʃɪp/'},
    {'word': 'Fluency', 'phonetic': '/ˈflu:ənsi/'},
    {'word': 'Vocabulary', 'phonetic': '/vəˈkæbjʊləri/'},
    {'word': 'Pronunciation', 'phonetic': '/prəˌnʌnsiˈeɪʃən/'},
    {'word': 'Professional', 'phonetic': '/prəˈfeʃənəl/'},
  ];

  static Map<String, String> getRandomPronunciationWord() {
    return _pronunciationWords[_random.nextInt(_pronunciationWords.length)];
  }

  // ---------------------------------------------------------------------
  // Fluency Topics
  // ---------------------------------------------------------------------
  static const List<String> _fluencyTopics = [
    'Describe a memorable experience from your student or professional life.',
    'Talk continuously about your favorite hobby or passion for 60 seconds.',
    'Explain how you spent your last weekend without using filler words like "um".',
    'Describe a place you would love to visit and explain why.',
    'Talk about a project you recently completed and what made it successful.',
    'Explain the steps you take to prepare for an important interview or presentation.',
    'Discuss how you handle unexpected changes in your daily routine.',
  ];

  static String getRandomFluencyTopic() {
    return _fluencyTopics[_random.nextInt(_fluencyTopics.length)];
  }

  // ---------------------------------------------------------------------
  // Grammar Questions
  // ---------------------------------------------------------------------
  static const List<Map<String, dynamic>> _grammarQuestions = [
    {
      'question': '"She go to college every day."',
      'options': [
        'She goes to college every day.',
        'She going to college every day.',
        'She go college every day.',
      ],
      'correctIndex': 0,
    },
    {
      'question': '"He don\'t know the answer."',
      'options': [
        'He not knowing the answer.',
        'He doesn\'t know the answer.',
        'He don\'t knows the answer.',
      ],
      'correctIndex': 1,
    },
    {
      'question': '"I am agree with your proposal."',
      'options': [
        'I am agreed with your proposal.',
        'I agreeing with your proposal.',
        'I agree with your proposal.',
      ],
      'correctIndex': 2,
    },
    {
      'question': '"Neither of the answers were correct."',
      'options': [
        'Neither of the answers was correct.',
        'Neither of the answers being correct.',
        'Neither answer were correct.',
      ],
      'correctIndex': 0,
    },
    {
      'question': '"Each student must submit their assignment yesterday."',
      'options': [
        'Each student must submit their assignment today.',
        'Each student submitted their assignment yesterday.',
        'Each student will submit their assignment yesterday.',
      ],
      'correctIndex': 1,
    },
  ];

  static List<Map<String, dynamic>> getGrammarQuestions() {
    final list = List<Map<String, dynamic>>.from(_grammarQuestions);
    list.shuffle(_random);
    return list;
  }

  // ---------------------------------------------------------------------
  // Vocabulary Words
  // ---------------------------------------------------------------------
  static const List<Map<String, dynamic>> _vocabularyWords = [
    {
      'word': 'Eloquent',
      'level': 'ADVANCED',
      'definition': 'Fluent or persuasive in speaking or writing',
      'example': '"She gave an eloquent speech that moved the audience."',
      'synonyms': ['articulate', 'expressive', 'fluent', 'persuasive'],
      'gradient': [Color(0xFFFF9100), Color(0xFFFF6D00)],
    },
    {
      'word': 'Resilient',
      'level': 'INTERMEDIATE',
      'definition': 'Able to withstand or recover quickly from difficult conditions',
      'example': '"He remained resilient throughout the tough interview process."',
      'synonyms': ['strong', 'tough', 'adaptable', 'flexible'],
      'gradient': [Color(0xFF534AE3), Color(0xFF7A6FFF)],
    },
    {
      'word': 'Meticulous',
      'level': 'ADVANCED',
      'definition': 'Showing great attention to detail; very careful and precise',
      'example': '"Her meticulous presentation left no question unanswered."',
      'synonyms': ['precise', 'thorough', 'scrupulous', 'accurate'],
      'gradient': [Color(0xFF00BFA5), Color(0xFF00ACC1)],
    },
    {
      'word': 'Pragmatic',
      'level': 'ADVANCED',
      'definition': 'Dealing with things sensibly and realistically based on practical considerations',
      'example': '"We need a pragmatic approach to solve this project delay."',
      'synonyms': ['practical', 'realistic', 'sensible', 'logical'],
      'gradient': [Color(0xFF9C27B0), Color(0xFFE91E63)],
    },
    {
      'word': 'Articulate',
      'level': 'INTERMEDIATE',
      'definition': 'Having or showing the ability to speak fluently and coherently',
      'example': '"An articulate communicator can explain complex technical ideas clearly."',
      'synonyms': ['eloquent', 'clear', 'coherent', 'expressive'],
      'gradient': [Color(0xFF00ACC1), Color(0xFF00BFA5)],
    },
  ];

  static Map<String, dynamic> getRandomVocabularyWord() {
    return _vocabularyWords[_random.nextInt(_vocabularyWords.length)];
  }

  // ---------------------------------------------------------------------
  // Confidence Challenges
  // ---------------------------------------------------------------------
  static const List<String> _confidenceChallenges = [
    '"Introduce yourself confidently as if speaking to a panel of senior managers."',
    '"Present a bold project proposal in 45 seconds with clear vocal authority."',
    '"Address an executive committee and explain why your team deserves project budget."',
    '"Deliver a 1-minute keynote speech inspiring junior colleagues to strive for excellence."',
    '"Defend your design decision firmly during a peer review session."',
  ];

  static String getRandomConfidenceChallenge() {
    return _confidenceChallenges[_random.nextInt(_confidenceChallenges.length)];
  }
}
