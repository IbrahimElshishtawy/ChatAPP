import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

class AnimatedAuthCard extends StatefulWidget {
  final Widget child;
  final bool flip;

  const AnimatedAuthCard({super.key, required this.child, this.flip = false});

  @override
  State<AnimatedAuthCard> createState() => _AnimatedAuthCardState();
}

class _AnimatedAuthCardState extends State<AnimatedAuthCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  double _tiltX = 0;
  double _tiltY = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _resetTilt() {
    setState(() {
      _tiltX = 0;
      _tiltY = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (d) {
        setState(() {
          _tiltY += d.delta.dx * 0.002;
          _tiltX -= d.delta.dy * 0.002;
          _tiltX = _tiltX.clamp(-0.2, 0.2);
          _tiltY = _tiltY.clamp(-0.2, 0.2);
        });
      },
      onPanEnd: (_) => _resetTilt(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          final idle = 0.03 * math.sin(_controller.value * math.pi * 2);
          final flipY = widget.flip
              ? 0.25 * math.sin(_controller.value * math.pi)
              : 0.0;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0018)
              ..rotateX(_tiltX + idle)
              ..rotateY(_tiltY + flipY)
              ..scale(1 + idle * 0.4),
            child: _GlassCard(child: widget.child),
          );
        },
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;

  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(26),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            padding: const EdgeInsets.all(22),
            constraints: const BoxConstraints(maxWidth: 380),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: Colors.white.withOpacity(0.25)),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
