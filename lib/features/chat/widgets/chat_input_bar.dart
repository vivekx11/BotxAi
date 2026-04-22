import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../shared/widgets/glass_container.dart';

class ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSend;
  final VoidCallback onVoice;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onVoice,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      margin: const EdgeInsets.all(AppSizes.paddingM),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingM,
        vertical: AppSizes.paddingS,
      ),
      child: Row(
        children: [
          // Voice Button
          IconButton(
            icon: const Icon(Icons.mic_rounded),
            color: AppColors.darkAccent1,
            onPressed: onVoice,
          ),
          
          // Text Input
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Ask me anything...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingM,
                ),
              ),
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: onSend,
            ),
          ),
          
          // Send Button
          IconButton(
            icon: const Icon(Icons.send_rounded),
            color: AppColors.darkAccent1,
            onPressed: () => onSend(controller.text),
          ),
        ],
      ),
    );
  }
}
