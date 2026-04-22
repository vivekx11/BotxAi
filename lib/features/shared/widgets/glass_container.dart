import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double blur;
  final Color? color;
  final Border? border;
  final Gradient? gradient;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.blur = AppSizes.glassBlur,
    this.color,
    this.border,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = isDark ? AppColors.darkGlass : AppColors.lightGlass;
    final defaultBorder = Border.all(
      color: isDark ? AppColors.glassBorderDark : AppColors.glassBorderLight,
      width: AppSizes.glassBorderWidth,
    );
    
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(AppSizes.radiusXL),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: gradient == null ? (color ?? defaultColor) : null,
              gradient: gradient,
              borderRadius: borderRadius ?? BorderRadius.circular(AppSizes.radiusXL),
              border: border ?? defaultBorder,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
