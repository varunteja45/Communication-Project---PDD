import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../providers/session_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_recording_button.dart';
import 'live_speech_analysis_screen.dart';
import 'results_screen.dart';

class PracticeSessionScreen extends StatefulWidget {
  const PracticeSessionScreen({super.key});

  @override
  State<PracticeSessionScreen> createState() => _PracticeSessionScreenState();
}

class _PracticeSessionScreenState extends State<PracticeSessionScreen> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final camStatus = await Permission.camera.status;
    if (!camStatus.isGranted) return;

    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        final frontCamera = cameras.firstWhere(
          (c) => c.lensDirection == CameraLensDirection.front,
          orElse: () => cameras.first,
        );

        _cameraController = CameraController(
          frontCamera,
          ResolutionPreset.medium,
          enableAudio: false,
        );

        await _cameraController!.initialize();
        if (mounted) {
          setState(() => _isCameraInitialized = true);
        }
      }
    } catch (e) {
      if (kDebugMode) print('Camera init error: $e');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sessionProvider = context.watch<SessionProvider>();
    final isListening = sessionProvider.state == RecordingState.listening;
    final isEvaluating = sessionProvider.state == RecordingState.evaluating;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0D25),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    '${sessionProvider.selectedEnvironment?.name ?? 'Practice'} Evaluation',
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Camera/Avatar Preview Area
            Expanded(
              flex: 4,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ..._buildCorners(),
                  
                  // Recording Badge
                  Positioned(
                    top: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: isListening ? Colors.red : Colors.grey,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isListening ? 'LIVE REC' : (isEvaluating ? 'EVALUATING' : 'READY'),
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Camera Preview Box
                  ClipOval(
                    child: SizedBox(
                      width: 150,
                      height: 150,
                      child: _isCameraInitialized && _cameraController != null && _cameraController!.value.isInitialized
                          ? CameraPreview(_cameraController!)
                          : Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF7A6FFF), Color(0xFF534AE3)],
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(color: const Color(0xFF534AE3).withOpacity(0.5), blurRadius: 30),
                                ],
                              ),
                              child: const Icon(Icons.videocam_rounded, size: 70, color: Colors.white24),
                            ),
                    ),
                  ),

                  // Timer
                  Positioned(
                    bottom: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        _formatTime(sessionProvider.elapsedSeconds),
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Question Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A174D),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${sessionProvider.selectedEnvironment?.name.toUpperCase() ?? 'COMMUNICATION'} SCENARIO',
                      style: const TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      sessionProvider.activePrompt,
                      style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600, height: 1.4),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // AI Status & Live Transcript Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LiveSpeechAnalysisScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [const Color(0xFF534AE3).withOpacity(0.3), const Color(0xFF534AE3).withOpacity(0.1)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF534AE3).withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.auto_awesome, color: AppTheme.accentTeal, size: 18),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          sessionProvider.liveTranscript.isNotEmpty
                              ? sessionProvider.liveTranscript
                              : (isListening
                                  ? 'Listening to microphone... speak clearly.'
                                  : 'Tap red mic button below to start live recording'),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ),
                      Row(
                        children: List.generate(
                          5,
                          (i) => Container(
                            margin: const EdgeInsets.only(left: 2),
                            width: 3,
                            height: 10 + (i % 2 * 10),
                            decoration: BoxDecoration(color: AppTheme.accentTeal, borderRadius: BorderRadius.circular(2)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Status Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  _buildStatusChip(
                    isListening ? 'Mic: Recording' : 'Mic: Ready',
                    Icons.mic_rounded,
                    isListening ? AppTheme.accentTeal : Colors.grey,
                  ),
                  const SizedBox(width: 12),
                  _buildStatusChip(
                    _isCameraInitialized ? 'Cam: Preview Active' : 'Cam: Standby',
                    Icons.videocam_rounded,
                    _isCameraInitialized ? AppTheme.accentTeal : Colors.grey,
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Control Buttons
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildIconButton(Icons.pause_rounded, () {}),
                  AnimatedRecordingButton(
                    isListening: isListening,
                    onTap: () async {
                      final micGranted = await Permission.microphone.isGranted;
                      if (!micGranted) {
                        final status = await Permission.microphone.request();
                        if (!status.isGranted) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Microphone permission is required to record audio.'),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                          return;
                        }
                      }

                      if (isListening) {
                        await sessionProvider.stopRecording();
                        if (mounted && sessionProvider.lastResult != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ResultsScreen(result: sessionProvider.lastResult!),
                            ),
                          );
                        }
                      } else {
                        await sessionProvider.startRecording();
                      }
                    },
                  ),
                  _buildIconButton(Icons.refresh_rounded, () {
                    sessionProvider.resetSession();
                  }),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                'Tap Mic to Start / Stop Voice Recording',
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Widget _buildStatusChip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.05),
          border: Border.all(color: Colors.white10),
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }

  List<Widget> _buildCorners() {
    const double size = 40;
    const double thickness = 2;
    const color = AppTheme.accentTeal;

    return [
      Positioned(
        top: 20,
        left: 20,
        child: Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: color, width: thickness), left: BorderSide(color: color, width: thickness)),
          ),
        ),
      ),
      Positioned(
        top: 20,
        right: 20,
        child: Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: color, width: thickness), right: BorderSide(color: color, width: thickness)),
          ),
        ),
      ),
      Positioned(
        bottom: 20,
        left: 20,
        child: Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: color, width: thickness), left: BorderSide(color: color, width: thickness)),
          ),
        ),
      ),
      Positioned(
        bottom: 20,
        right: 20,
        child: Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: color, width: thickness), right: BorderSide(color: color, width: thickness)),
          ),
        ),
      ),
    ];
  }
}
