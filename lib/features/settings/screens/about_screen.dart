import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_sizes.dart';
import '../../shared/widgets/animated_gradient_bg.dart';
import '../../shared/widgets/glass_container.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSizes.paddingM),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      onPressed: () => context.pop(),
                    ),
                    const Expanded(
                      child: Text(
                        AppStrings.aboutTitle,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(AppSizes.paddingXL),
                  children: [
                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: AppColors.userMessageGradient,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Icon(
                          Icons.smart_toy_rounded,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.spaceXL),
                    const Text(
                      AppStrings.appName,
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSizes.spaceM),
                    Text(
                      '${AppStrings.aboutVersion} ${AppStrings.appVersion}',
                      style: const TextStyle(fontSize: 16, color: AppColors.darkMuted),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSizes.spaceXXL),
                    GlassContainer(
                      padding: const EdgeInsets.all(AppSizes.paddingXL),
                      child: const Text(
                        AppStrings.aboutDescription,
                        style: TextStyle(fontSize: 16, height: 1.5),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spaceXL),
                    const Text(
                      AppStrings.aboutDeveloper,
                      style: TextStyle(fontSize: 14, color: AppColors.darkMuted),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
