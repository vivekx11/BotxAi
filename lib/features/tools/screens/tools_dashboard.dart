import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_sizes.dart';
import '../../shared/widgets/animated_gradient_bg.dart';
import '../../shared/widgets/glass_container.dart';

class ToolsDashboard extends StatelessWidget {
  const ToolsDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
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
                        AppStrings.toolsTitle,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              
              // Tools Grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(AppSizes.paddingM),
                  mainAxisSpacing: AppSizes.spaceM,
                  crossAxisSpacing: AppSizes.spaceM,
                  children: [
                    _ToolCard(
                      icon: Icons.calculate_rounded,
                      title: AppStrings.calculator,
                      gradient: [AppColors.darkAccent1, AppColors.darkAccent2],
                      onTap: () => context.push('/calculator'),
                    ),
                    _ToolCard(
                      icon: Icons.note_rounded,
                      title: AppStrings.notes,
                      gradient: [AppColors.darkAccent2, AppColors.gradientPink],
                      onTap: () => context.push('/notes'),
                    ),
                    _ToolCard(
                      icon: Icons.wb_sunny_rounded,
                      title: AppStrings.weather,
                      gradient: [AppColors.gradientPink, AppColors.gradientOrange],
                      onTap: () => context.push('/weather'),
                    ),
                    _ToolCard(
                      icon: Icons.translate_rounded,
                      title: AppStrings.translator,
                      gradient: [AppColors.gradientOrange, AppColors.darkAccent1],
                      onTap: () => context.push('/translator'),
                    ),
                    _ToolCard(
                      icon: Icons.contacts_rounded,
                      title: AppStrings.contacts,
                      gradient: [AppColors.darkAccent1, AppColors.gradientPink],
                      onTap: () {},
                    ),
                    _ToolCard(
                      icon: Icons.battery_charging_full_rounded,
                      title: AppStrings.battery,
                      gradient: [AppColors.darkAccent2, AppColors.gradientOrange],
                      onTap: () {},
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

class _ToolCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _ToolCard({
    required this.icon,
    required this.title,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                size: 32,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: AppSizes.spaceM),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
