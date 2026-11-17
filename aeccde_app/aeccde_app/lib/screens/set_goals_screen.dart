import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import 'profile_setup_screen.dart';

class SetGoalsScreen extends StatefulWidget {
  const SetGoalsScreen({super.key});

  @override
  State<SetGoalsScreen> createState() => _SetGoalsScreenState();
}

class _SetGoalsScreenState extends State<SetGoalsScreen> {
  final List<Map<String, dynamic>> _goals = [
    {'label': 'Interview Skills', 'icon': Icons.work_rounded, 'selected': true},
    {'label': 'Public Speaking', 'icon': Icons.mic_external_on_rounded, 'selected': true},
    {'label': 'Classroom Communication', 'icon': Icons.school_rounded, 'selected': false},
    {'label': 'Meeting Communication', 'icon': Icons.groups_rounded, 'selected': false},
    {'label': 'Group Discussion', 'icon': Icons.forum_rounded, 'selected': false},
    {'label': 'Everyday Conversation', 'icon': Icons.chat_bubble_rounded, 'selected': false},
    {'label': 'Pronunciation', 'icon': Icons.abc_rounded, 'selected': false},
    {'label': 'Fluency', 'icon': Icons.bolt_rounded, 'selected': false},
    {'label': 'Confidence', 'icon': Icons.fitness_center_rounded, 'selected': false},
  ];

  int get _selectedCount => _goals.where((g) => g['selected'] == true).length;

  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Set Your Goals',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: FadeInDown(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.auto_awesome, color: Color(0xFF534AE3), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'What Do You Want to Improve?',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select all that apply. You can change this later.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: FadeInUp(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: _goals.length,
                itemBuilder: (context, index) {
                  final goal = _goals[index];
                  final isSelected = goal['selected'];

                  return InkWell(
                    onTap: () {
                      setState(() {
                        _goals[index]['selected'] = !isSelected;
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF534AE3)
                              : Colors.grey.shade100,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                goal['icon'],
                                size: 32,
                                color: isSelected
                                    ? const Color(0xFF534AE3)
                                    : Colors.grey.shade400,
                              ),
                              const SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  goal['label'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? const Color(0xFF534AE3)
                                        : Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (isSelected)
                            Positioned(
                              bottom: 8,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF534AE3),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          if (_selectedCount > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: FadeIn(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDEEFC),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.auto_awesome, color: Color(0xFF534AE3), size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '$_selectedCount goals selected — AI will personalize your plan!',
                          style: const TextStyle(
                            color: Color(0xFF534AE3),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: FadeInUp(
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _selectedCount > 0
                      ? () async {
                          final selected = _goals
                              .where((g) => g['selected'] == true)
                              .map((g) => g['label'] as String)
                              .toList();
                          await userProvider.updateGoals(selected);

                          if (context.mounted) {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const ProfileSetupScreen()),
                            );
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF534AE3),
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Continue ($_selectedCount selected)',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
