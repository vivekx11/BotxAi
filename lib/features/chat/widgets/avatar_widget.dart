import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';

class AvatarWidget extends StatelessWidget {
  final bool isAnimating;
  final double size;

  const AvatarWidget({
    super.key,
    this.isAnimating = false,
    this.size = 36,
  });

  @override
  Widget build(BuildContext context) {
    Widget avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: AppColors.userMessageGradient,
        borderRadius: BorderRadius.circular(size * 0.25),
      ),
      child: Icon(
        Icons.smart_toy_rounded,
        color: Colors.white,
        size: size * 0.55,
      ),
    );

    if (isAnimating) {
      avatar = avatar
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .moveY(
            begin: 0,
            end: -4,
            duration: 1000.ms,
            curve: Curves.easeInOut,
          );
    }

    return avatar;
  }
}
