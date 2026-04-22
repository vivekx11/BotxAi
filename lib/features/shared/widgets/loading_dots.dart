import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';

class LoadingDots extends StatelessWidget {
  final Color? color;
  final double size;

  const LoadingDots({
    super.key,
    this.color,
    this.size = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final dotColor = color ?? AppColors.darkAccent1;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDot(dotColor, 0),
        const SizedBox(width: 4),
        _buildDot(dotColor, 1),
        const SizedBox(width: 4),
        _buildDot(dotColor, 2),
      ],
    );
  }

  Widget _buildDot(Color color, int index) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    )
        .animate(onPlay: (controller) => controller.repeat())
        .fadeIn(
          duration: 600.ms,
          delay: (index * 200).ms,
        )
        .then()
        .fadeOut(duration: 600.ms);
  }
}
