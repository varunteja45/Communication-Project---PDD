import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:permission_handler/permission_handler.dart';

import 'pre_evaluation_check_screen.dart';
import '../models/environment_model.dart';

class PermissionsScreen extends StatefulWidget {
  final EnvironmentModel? environment;
  const PermissionsScreen({super.key, this.environment});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  bool micEnabled = false;
  bool camEnabled = false;
  bool speechEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkCurrentPermissions();
  }

  Future<void> _checkCurrentPermissions() async {
    final mic = await Permission.microphone.status;
    final cam = await Permission.camera.status;
    final speech = await Permission.speech.status;

    if (mounted) {
      setState(() {
        micEnabled = mic.isGranted;
        camEnabled = cam.isGranted;
        speechEnabled = speech.isGranted || speech.isLimited;
      });
    }
  }

  Future<void> _requestAndVerifyPermissions() async {
    // If ANY option switch is turned OFF by the user, block navigation!
    if (!micEnabled || !camEnabled || !speechEnabled) {
      _showOptionDisabledDialog();
      return;
    }

    final micStatus = await Permission.microphone.request();
    final camStatus = await Permission.camera.request();
    final speechStatus = await Permission.speech.request();

    final micGranted = micStatus.isGranted;
    final camGranted = camStatus.isGranted;
    final speechGranted = speechStatus.isGranted || speechStatus.isLimited;

    if (mounted) {
      setState(() {
        micEnabled = micGranted;
        camEnabled = camGranted;
        speechEnabled = speechGranted;
      });
    }

    if (!micGranted || !camGranted || !speechGranted) {
      if (micStatus.isPermanentlyDenied || camStatus.isPermanentlyDenied || speechStatus.isPermanentlyDenied) {
        _showPermanentlyDeniedDialog();
      } else {
        _showRationaleDialog();
      }
      return; // DO NOT navigate unless all 3 options & system permissions are allowed!
    }

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreEvaluationCheckScreen(environment: widget.environment),
        ),
      );
    }
  }

  void _showOptionDisabledDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 8),
            Text('Options Disabled', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: const Text(
          'Please turn ON all three options (Microphone, Camera, and Speech Recognition) to proceed with AI analysis.',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                micEnabled = true;
                camEnabled = true;
                speechEnabled = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF534AE3),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Turn ON All Options', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showRationaleDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.security_rounded, color: Color(0xFF534AE3)),
            SizedBox(width: 8),
            Text('Permissions Required', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: const Text(
          'Microphone, Camera, and Speech Recognition permissions are strictly required to record your speech, analyze your communication pace, and evaluate your delivery. Please allow all permissions to continue.',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _requestAndVerifyPermissions();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF534AE3),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Grant Permissions', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showPermanentlyDeniedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.settings_rounded, color: Colors.redAccent),
            SizedBox(width: 8),
            Text('Permissions Denied', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: const Text(
          'Camera, Microphone, or Speech Recognition access has been permanently denied in system settings. Please open App Settings to grant all 3 permissions before starting an evaluation.',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              openAppSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Open App Settings', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

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
          'Enable AI Analysis',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              FadeInDown(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF0F2FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.auto_awesome, size: 50, color: Color(0xFF534AE3)),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Grant Permissions',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Camera, microphone, and speech recognition access help analyze your speech and communication behavior for accurate evaluation.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.4),
              ),
              const SizedBox(height: 24),
              _buildPermissionTile(
                'Microphone',
                'For live voice recording & speech analysis',
                Icons.mic_rounded,
                micEnabled,
                (val) async {
                  if (val) {
                    final status = await Permission.microphone.request();
                    setState(() => micEnabled = status.isGranted);
                  } else {
                    setState(() => micEnabled = false);
                  }
                },
              ),
              const SizedBox(height: 12),
              _buildPermissionTile(
                'Camera',
                'For live expression & visual preview',
                Icons.camera_alt_rounded,
                camEnabled,
                (val) async {
                  if (val) {
                    final status = await Permission.camera.request();
                    setState(() => camEnabled = status.isGranted);
                  } else {
                    setState(() => camEnabled = false);
                  }
                },
              ),
              const SizedBox(height: 12),
              _buildPermissionTile(
                'Speech Recognition',
                'For live NLP & transcript analysis',
                Icons.psychology_rounded,
                speechEnabled,
                (val) async {
                  if (val) {
                    final status = await Permission.speech.request();
                    setState(() => speechEnabled = status.isGranted || status.isLimited);
                  } else {
                    setState(() => speechEnabled = false);
                  }
                },
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lock_outline_rounded, size: 18, color: Color(0xFF2E7D32)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your speech is processed locally on-device for maximum privacy.',
                        style: TextStyle(fontSize: 11, color: Colors.green.shade800, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _requestAndVerifyPermissions,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF534AE3),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text(
                    'Allow Access & Continue',
                    style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionTile(String title, String subtitle, IconData icon, bool value, Function(bool) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: Colors.grey.shade600, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF534AE3),
          ),
        ],
      ),
    );
  }
}
