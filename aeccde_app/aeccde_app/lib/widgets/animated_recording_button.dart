import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Pulsing mic button used on the practice session screen. Pulses
/// while [isListening] is true, static otherwise.
class AnimatedRecordingButton extends StatefulWidget {
  final bool isListening;
  final VoidCallback onTap;

  const AnimatedRecordingButton({super.key, required this.isListening, required this.onTap});

  @override
  State<AnimatedRecordingButton> createState() => _AnimatedRecordingButtonState();
}

class _AnimatedRecordingButtonState extends State<AnimatedRecordingButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isListening ? AppTheme.accentRed : AppTheme.primary;
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final scale = widget.isListening ? 1 + (_controller.value * 0.12) : 1.0;
          return Stack(
            alignment: Alignment.center,
            children: [
              if (widget.isListening)
                Transform.scale(
                  scale: 1.4 + (_controller.value * 0.5),
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withOpacity(0.15 * (1 - _controller.value)),
                    ),
                  ),
                ),
              Transform.scale(
                scale: scale,
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                    boxShadow: [
                      BoxShadow(color: color.withOpacity(0.4), blurRadius: 20, spreadRadius: 2),
                    ],
                  ),
                  child: Icon(
                    widget.isListening ? Icons.stop_rounded : Icons.mic_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
