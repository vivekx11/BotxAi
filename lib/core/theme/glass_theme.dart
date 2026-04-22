import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

class GlassTheme {
  GlassTheme._();
  
  static BoxDecoration darkGlassDecoration({
    BorderRadius? borderRadius,
    Border? border,
  }) {
    return BoxDecoration(
      color: AppColors.darkGlass,
      borderRadius: borderRadius ?? BorderRadius.circular(AppSizes.radiusXL),
      border: border ?? Border.all(
        color: AppColors.glassBorderDark,
        width: AppSizes.glassBorderWidth,
      ),
    );
  }
  
  static BoxDecoration lightGlassDecoration({
    BorderRadius? borderRadius,
    Border? border,
  }) {
    return BoxDecoration(
      color: AppColors.lightGlass,
      borderRadius: borderRadius ?? BorderRadius.circular(AppSizes.radiusXL),
      border: border ?? Border.all(
        color: AppColors.glassBorderLight,
        width: AppSizes.glassBorderWidth,
      ),
    );
  }
  
  static Widget glassBlur({
    required Widget child,
    double blur = AppSizes.glassBlur,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.radiusXL),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: child,
      ),
    );
  }
  
  static BoxDecoration gradientGlassDecoration({
    required List<Color> colors,
    BorderRadius? borderRadius,
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: colors,
        begin: begin,
        end: end,
      ),
      borderRadius: borderRadius ?? BorderRadius.circular(AppSizes.radiusXL),
      border: Border.all(
        color: Colors.white.withOpacity(0.2),
        width: AppSizes.glassBorderWidth,
      ),
    );
  }
}
