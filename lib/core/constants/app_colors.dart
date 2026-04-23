// app colour 

import 'package:flutter/material.dart';
// app constant 
class AppColors {
  AppColors._();
  
  // Dark Mode Colors
  static const darkBackground = Color(0xFF0A0A14);
  static const darkSurface = Color(0xFF13131F);
  static const darkGlass = Color(0x0FFFFFFF); // rgba(255,255,255,0.06)
  static const darkAccent1 = Color(0xFF7C5CFC); // Purple
  static const darkAccent2 = Color(0xFF00D4C8); // Teal
  static const darkAccent3 = Color(0xFFFF6B6B); // Coral
  static const darkText = Color(0xFFF0F0FF);
  static const darkMuted = Color(0xFF8888AA);
  
  // Light Mode Colors
  static const lightBackground = Color(0xFFF5F5F9);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightGlass = Color(0x14000000); // rgba(0,0,0,0.08)
  static const lightAccent1 = Color(0xFF6B4CE6);
  static const lightAccent2 = Color(0xFF00BDB0);
  static const lightAccent3 = Color(0xFFFF5252);
  static const lightText = Color(0xFF1A1A2E);
  static const lightMuted = Color(0xFF6B6B8A);
  
  // Gradient Colors
  static const gradientPurple = Color(0xFF7C5CFC);
  static const gradientTeal = Color(0xFF00D4C8);
  static const gradientPink = Color(0xFFFF6B9D);
  static const gradientOrange = Color(0xFFFF8C42);
  
  // Glass Border
  static const glassBorderDark = Color(0x2DFFFFFF); // rgba(255,255,255,0.18)
  static const glassBorderLight = Color(0x1F000000); // rgba(0,0,0,0.12)
  
  // Status Colors
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFFC107);
  static const error = Color(0xFFFF5252);
  static const info = Color(0xFF2196F3);
  
  // User Message Gradient
  static LinearGradient get userMessageGradient => const LinearGradient(
        colors: [gradientPurple, gradientTeal],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
  
  // Background Mesh Gradient (Dark)
  static List<Color> get darkMeshColors => [
        const Color(0xFF1A0B2E),
        const Color(0xFF0F1B3D),
        const Color(0xFF16213E),
        const Color(0xFF0A0E27),
      ];
  
  // Background Mesh Gradient (Light)
  static List<Color> get lightMeshColors => [
        const Color(0xFFE8E4F3),
        const Color(0xFFD4E4F7),
        const Color(0xFFE0F2F7),
        const Color(0xFFF0E6F6),
      ];
}
