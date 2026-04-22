import 'package:flutter/material.dart';
import '../../../core/constants/app_sizes.dart';
import 'glass_container.dart';

class BotXAppBar extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final Widget? leading;

  const BotXAppBar({
    super.key,
    required this.title,
    this.onBackPressed,
    this.actions,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      margin: const EdgeInsets.all(AppSizes.paddingM),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingL,
        vertical: AppSizes.paddingM,
      ),
      child: Row(
        children: [
          if (leading != null)
            leading!
          else if (onBackPressed != null)
            IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: onBackPressed,
            ),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (actions != null) ...actions! else const SizedBox(width: 48),
        ],
      ),
    );
  }
}
