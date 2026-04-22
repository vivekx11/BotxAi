import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../domain/suggestion_engine.dart';
import '../providers/chat_provider.dart';

class SuggestionChips extends ConsumerWidget {
  const SuggestionChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesAsync = ref.watch(chatMessagesProvider);
    
    return messagesAsync.when(
      data: (messages) {
        final suggestions = SuggestionEngine.generateSuggestions(
          lastBotMessage: messages.isNotEmpty && messages.last.isBot
              ? messages.last.content
              : null,
        );
        
        return Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingM),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: suggestions.length,
            separatorBuilder: (context, index) => const SizedBox(width: AppSizes.spaceS),
            itemBuilder: (context, index) {
              return _SuggestionChip(
                label: suggestions[index],
                onTap: () {
                  ref.read(chatMessagesProvider.notifier).sendMessage(suggestions[index]);
                },
              );
            },
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SuggestionChip({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingL,
          vertical: AppSizes.paddingS,
        ),
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(AppSizes.radiusXL),
          border: Border.all(
            color: AppColors.darkAccent1.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.darkText,
          ),
        ),
      ),
    );
  }
}
