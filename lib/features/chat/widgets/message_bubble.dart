import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/date_utils.dart';
import '../../shared/widgets/glass_container.dart';
import '../domain/chat_message.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final VoidCallback? onLongPress;

  const MessageBubble({
    super.key,
    required this.message,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    
    return GestureDetector(
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingS),
        child: Row(
          mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isUser) ...[
              _buildAvatar(),
              const SizedBox(width: AppSizes.spaceS),
            ],
            Flexible(
              child: Column(
                crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  _buildBubble(context, isUser),
                  const SizedBox(height: AppSizes.spaceXS),
                  Text(
                    AppDateUtils.formatMessageTime(message.timestamp),
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.darkMuted,
                    ),
                  ),
                ],
              ),
            ),
            if (isUser) const SizedBox(width: AppSizes.spaceS),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.2, end: 0, duration: 300.ms);
  }

  Widget _buildAvatar() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        gradient: AppColors.userMessageGradient,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.smart_toy_rounded,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  Widget _buildBubble(BuildContext context, bool isUser) {
    if (isUser) {
      return Container(
        constraints: const BoxConstraints(
          maxWidth: AppSizes.messageBubbleMaxWidth,
        ),
        padding: const EdgeInsets.all(AppSizes.messageBubblePadding),
        decoration: BoxDecoration(
          gradient: AppColors.userMessageGradient,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppSizes.radiusXL),
            topRight: Radius.circular(AppSizes.radiusS),
            bottomLeft: Radius.circular(AppSizes.radiusXL),
            bottomRight: Radius.circular(AppSizes.radiusXL),
          ),
        ),
        child: Text(
          message.content,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            height: 1.4,
          ),
        ),
      );
    } else {
      return GlassContainer(
        padding: const EdgeInsets.all(AppSizes.messageBubblePadding),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSizes.radiusS),
          topRight: Radius.circular(AppSizes.radiusXL),
          bottomLeft: Radius.circular(AppSizes.radiusXL),
          bottomRight: Radius.circular(AppSizes.radiusXL),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSizes.messageBubbleMaxWidth,
          ),
          child: Text(
            message.content,
            style: const TextStyle(
              fontSize: 15,
              height: 1.4,
            ),
          ),
        ),
      );
    }
  }
}
