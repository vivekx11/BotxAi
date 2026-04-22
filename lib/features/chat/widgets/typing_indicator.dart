import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../shared/widgets/glass_container.dart';

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: AppColors.userMessageGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.smart_toy_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSizes.spaceS),
          GlassContainer(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingL,
              vertical: AppSizes.paddingM,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppSizes.radiusS),
              topRight: Radius.circular(AppSizes.radiusXL),
              bottomLeft: Radius.circular(AppSizes.radiusXL),
              bottomRight: Radius.circular(AppSizes.radiusXL),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0),
                const SizedBox(width: 4),
                _buildDot(1),
                const SizedBox(width: 4),
                _buildDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: AppColors.darkAccent1,
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
