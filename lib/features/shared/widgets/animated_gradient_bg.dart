import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;
  
  const AnimatedGradientBackground({
    super.key,
    required this.child,
  });

  @override
  State<AnimatedGradientBackground> createState() => _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);
    
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.darkMeshColors : AppColors.lightMeshColors;
    
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: GradientMeshPainter(
            colors: colors,
            animation: _animation.value,
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class GradientMeshPainter extends CustomPainter {
  final List<Color> colors;
  final double animation;

  GradientMeshPainter({
    required this.colors,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    // Draw multiple radial gradients for mesh effect
    final positions = [
      Offset(size.width * 0.2, size.height * (0.2 + animation * 0.1)),
      Offset(size.width * 0.8, size.height * (0.3 - animation * 0.1)),
      Offset(size.width * 0.5, size.height * (0.7 + animation * 0.15)),
      Offset(size.width * 0.1, size.height * (0.8 - animation * 0.1)),
    ];
    
    for (int i = 0; i < positions.length; i++) {
      paint.shader = RadialGradient(
        colors: [
          colors[i % colors.length].withOpacity(0.3),
          colors[i % colors.length].withOpacity(0.0),
        ],
        stops: const [0.0, 1.0],
      ).createShader(
        Rect.fromCircle(
          center: positions[i],
          radius: size.width * 0.6,
        ),
      );
      
      canvas.drawCircle(positions[i], size.width * 0.6, paint);
    }
  }

  @override
  bool shouldRepaint(GradientMeshPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}
