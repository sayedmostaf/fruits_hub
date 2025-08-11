import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruits_hub/core/services/firebase_auth_service.dart';
import 'package:fruits_hub/core/services/shared_preferences.dart';
import 'package:fruits_hub/core/utils/app_images.dart';
import 'package:fruits_hub/core/utils/constants.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _particleAnimation;

  @override
  void initState() {
    super.initState();
    _navigate();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    _particleAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.2,
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.95),
            Theme.of(context).colorScheme.secondary.withOpacity(0.85),
            Theme.of(context).colorScheme.primaryContainer.withOpacity(0.7),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Particle effect background
          AnimatedBuilder(
            animation: _particleAnimation,
            builder:
                (context, child) => CustomPaint(
                  painter: _ParticlePainter(_particleAnimation.value),
                  size: Size.infinite,
                ),
          ),
          // Background plant illustration
          Positioned(
            top: -20,
            left: -20,
            child: FadeInLeft(
              duration: const Duration(milliseconds: 1200),
              delay: const Duration(milliseconds: 200),
              child: SvgPicture.asset(Assets.imagesPlant, height: 180),
            ),
          ),
          // Centered logo with combined zoom and bounce animation
          Center(
            child: BounceInDown(
              duration: const Duration(milliseconds: 1000),
              delay: const Duration(milliseconds: 300),
              child: ZoomIn(
                duration: const Duration(milliseconds: 800),
                child: SvgPicture.asset(Assets.imagesLogo, width: 150),
              ),
            ),
          ),
          // Bottom illustration
          Positioned(
            bottom: -10,
            left: 0,
            right: 0,
            child: FadeInUp(
              duration: const Duration(milliseconds: 1000),
              delay: const Duration(milliseconds: 400),
              child: SvgPicture.asset(
                Assets.imagesSplashBottom,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Progress indicator
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: FadeInUp(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 500),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.onPrimary.withOpacity(0.9),
                ),
                strokeWidth: 2.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigate() {
    final isOnBoardingSeen = Pref.getBool(Constants.isOnBoardingViewSeen);
    final isLoggedIn = FirebaseAuthService().isUserLoggedIn();
    Future.delayed(const Duration(seconds: 4), () {
      final route =
          isOnBoardingSeen
              ? isLoggedIn
                  ? Constants.mainNavigationViewRoute
                  : Constants.loginViewRoute
              : Constants.onboardingViewRoute;
      Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
    });
  }
}

// Particle effect painter for subtle background animation
class _ParticlePainter extends CustomPainter {
  final double animationValue;

  _ParticlePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.white.withOpacity(0.1);

    for (int i = 0; i < 20; i++) {
      final offset = Offset(
        size.width * (i % 5) / 5 + (sin(animationValue * 2 * 3.14 + i) * 20),
        size.height * (i ~/ 5) / 4 + (cos(animationValue * 2 * 3.14 + i) * 20),
      );
      canvas.drawCircle(offset, 2 + (sin(animationValue + i) * 2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
