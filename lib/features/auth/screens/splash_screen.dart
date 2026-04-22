import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_sizes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: AppSizes.splashDuration));
    
    if (!mounted) return;
    
    // Check if user has completed onboarding
    final box = Hive.box('settings');
    final hasCompletedOnboarding = box.get('onboarding_completed', defaultValue: false);
    
    if (hasCompletedOnboarding) {
      context.go('/chat');
    } else {
      context.go('/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // AI Robot Icon (placeholder - would be Lottie in production)
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.darkAccent1,
                    AppColors.darkAccent2,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.smart_toy_rounded,
                size: 64,
                color: Colors.white,
              ),
            )
                .animate()
                .scale(
                  duration: 600.ms,
                  curve: Curves.elasticOut,
                )
                .fadeIn(duration: 400.ms),
            
            const SizedBox(height: AppSizes.spaceXL),
            
            // App Name with Shimmer
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  AppColors.darkAccent1,
                  AppColors.darkAccent2,
                  AppColors.darkAccent1,
                ],
                stops: const [0.0, 0.5, 1.0],
              ).createShader(bounds),
              child: Text(
                AppStrings.appName,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )
                .animate(onPlay: (controller) => controller.repeat())
                .shimmer(
                  duration: 2000.ms,
                  color: Colors.white.withOpacity(0.5),
                )
                .fadeIn(duration: 600.ms, delay: 200.ms),
            
            const SizedBox(height: AppSizes.spaceM),
            
            // Tagline
            Text(
              AppStrings.appTagline,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? AppColors.darkMuted : AppColors.lightMuted,
              ),
            )
                .animate()
                .fadeIn(duration: 600.ms, delay: 400.ms)
                .slideY(begin: 0.3, end: 0, duration: 600.ms, delay: 400.ms),
            
            const SizedBox(height: AppSizes.spaceXXL),
            
            // Loading Indicator
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isDark ? AppColors.darkAccent1 : AppColors.lightAccent1,
                ),
              ),
            )
                .animate()
                .fadeIn(duration: 600.ms, delay: 800.ms),
            
            const SizedBox(height: AppSizes.spaceL),
            
            // Version
            Text(
              'v${AppStrings.appVersion}',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.darkMuted : AppColors.lightMuted,
              ),
            )
                .animate()
                .fadeIn(duration: 600.ms, delay: 1000.ms),
          ],
        ),
      ),
    );
  }
}
