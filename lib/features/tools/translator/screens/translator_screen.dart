import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../shared/widgets/animated_gradient_bg.dart';
import '../../../shared/widgets/glass_container.dart';

class TranslatorScreen extends StatelessWidget {
  const TranslatorScreen({super.key});

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
                        AppStrings.translatorTitle,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.paddingM),
                  child: Column(
                    children: [
                      GlassContainer(
                        padding: const EdgeInsets.all(AppSizes.paddingL),
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText: AppStrings.translatorPlaceholder,
                            border: InputBorder.none,
                          ),
                          maxLines: 5,
                        ),
                      ),
                      const SizedBox(height: AppSizes.spaceL),
                      GlassContainer(
                        padding: const EdgeInsets.all(AppSizes.paddingL),
                        child: const SizedBox(
                          width: double.infinity,
                          height: 150,
                          child: Center(
                            child: Text(
                              'Translation will appear here',
                              style: TextStyle(color: AppColors.darkMuted),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
