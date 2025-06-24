import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fruits_hub/features/product_details/presentation/view/widgets/back_arrow_button.dart';
import 'dart:ui';

class HalfEclipseBackground extends StatelessWidget {
  const HalfEclipseBackground({super.key, required this.imageUrl});
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: HalfOvalClipper(context: context),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFF3F5F7), Color(0xFFE8F5E9)],
              ),
            ),
          ),
        ),
        const Padding(padding: EdgeInsets.all(8.0), child: BackArrowButton()),
        // Glassmorphism effect behind the image
        Positioned(
          top: MediaQuery.of(context).size.height * 0.13,
          left: MediaQuery.of(context).size.width * 0.18,
          right: MediaQuery.of(context).size.width * 0.18,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                height: 210,
                width: 210,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ),
        // Product image with shadow and shimmer
        Positioned(
          bottom: 0,
          top: 0,
          right: 0,
          left: 0,
          child: Center(child: _ShimmerImage(imageUrl: imageUrl)),
        ),
      ],
    );
  }
}

class HalfOvalClipper extends CustomClipper<Path> {
  final BuildContext context;

  HalfOvalClipper({super.reclip, required this.context});
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 100); // بداية المسار من الأسفل
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 80,
    ); // منحنى داخلي
    path.lineTo(size.width, 0); // إغلاق الشكل
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Modern shimmer effect for the product image
class _ShimmerImage extends StatefulWidget {
  final String imageUrl;
  const _ShimmerImage({required this.imageUrl});
  @override
  State<_ShimmerImage> createState() => _ShimmerImageState();
}

class _ShimmerImageState extends State<_ShimmerImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: false);
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
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.18),
                    blurRadius: 40,
                    offset: const Offset(0, 24),
                  ),
                ],
                borderRadius: BorderRadius.circular(24),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: CachedNetworkImage(
                  imageUrl: widget.imageUrl,
                  height: 187,
                  width: 201,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Shimmer overlay
            Positioned.fill(
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.18,
                  child: ShaderMask(
                    shaderCallback: (rect) {
                      return LinearGradient(
                        begin: Alignment(-1.0 + 2.0 * _controller.value, -1.0),
                        end: Alignment(1.0 + 2.0 * _controller.value, 1.0),
                        colors: [
                          Colors.white,
                          Colors.white.withOpacity(0.0),
                          Colors.white,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ).createShader(rect);
                    },
                    blendMode: BlendMode.srcATop,
                    child: Container(
                      height: 187,
                      width: 201,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
