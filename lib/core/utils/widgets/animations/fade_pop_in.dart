import 'package:flutter/material.dart';

class FadePopInAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration, reverseDuration;
  final Curve curve;
  final bool visible;
  final bool maintainState;
  const FadePopInAnimation({
    super.key,
    required this.child,
    required this.visible,
    this.duration = const Duration(milliseconds: 300),
    this.reverseDuration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.maintainState = false,
  });

  @override
  State<FadePopInAnimation> createState() => _FadePopInAnimationState();
}

class _FadePopInAnimationState extends State<FadePopInAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      reverseDuration: widget.reverseDuration ?? widget.duration,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
    _updateVisibility();
  }

  @override
  void didUpdateWidget(covariant FadePopInAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible != oldWidget.visible) {
      _updateVisibility();
    }
  }

  void _updateVisibility() {
    if (widget.visible) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Visibility(
          maintainState: widget.maintainState,
          visible: widget.maintainState || _controller.value > 0.0,
          child: FadeTransition(opacity: _fadeAnimation, child: widget.child),
        );
      },
    );
  }
}
