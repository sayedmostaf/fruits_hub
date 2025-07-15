import 'package:flutter/material.dart';

class PopOutToBottomAnimation extends StatefulWidget {
  const PopOutToBottomAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    required this.visible,
  });
  final Widget child;
  final Duration duration;
  final bool visible;
  @override
  State<PopOutToBottomAnimation> createState() =>
      _PopOutToBottomAnimationState();
}

class _PopOutToBottomAnimationState extends State<PopOutToBottomAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 1),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PopOutToBottomAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible != oldWidget.visible) {
      if (!widget.visible) {
        _controller.forward();
      } else {
        _controller.reset();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: FadeTransition(opacity: _fadeAnimation, child: widget.child),
    );
  }
}
