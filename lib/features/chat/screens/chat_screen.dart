import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_sizes.dart';
import '../../shared/widgets/animated_gradient_bg.dart';
import '../../shared/widgets/glass_container.dart';
import '../providers/chat_provider.dart';
import '../widgets/message_bubble.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/suggestion_chips.dart';
import '../widgets/typing_indicator.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    
    _textController.clear();
    ref.read(isTypingProvider.notifier).state = true;
    
    await ref.read(chatMessagesProvider.notifier).sendMessage(text);
    
    ref.read(isTypingProvider.notifier).state = false;
    
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(chatMessagesProvider);
    final isTyping = ref.watch(isTypingProvider);
    
    return Scaffold(
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              _buildAppBar(context),
              
              // Messages List
              Expanded(
                child: messagesAsync.when(
                  data: (messages) {
                    if (messages.isEmpty) {
                      return _buildEmptyState();
                    }
                    
                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(AppSizes.paddingM),
                      itemCount: messages.length + (isTyping ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == messages.length && isTyping) {
                          return const TypingIndicator();
                        }
                        
                        final message = messages[index];
                        return MessageBubble(
                          message: message,
                          onLongPress: () => _showMessageOptions(context, message.id),
                        );
                      },
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, stack) => Center(
                    child: Text('Error: $error'),
                  ),
                ),
              ),
              
              // Suggestion Chips
              const SuggestionChips(),
              
              // Input Bar
              ChatInputBar(
                controller: _textController,
                onSend: _sendMessage,
                onVoice: () => context.push('/voice'),
              ),
            ],
          ),
        ),
      ),
      drawer: _buildDrawer(context),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return GlassContainer(
      margin: const EdgeInsets.all(AppSizes.paddingM),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingL,
        vertical: AppSizes.paddingM,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
          const SizedBox(width: AppSizes.spaceM),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: AppColors.userMessageGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.smart_toy_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSizes.spaceM),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.appName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Online',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.darkMuted,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
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
          const SizedBox(height: AppSizes.spaceXL),
          const Text(
            AppStrings.chatWelcome,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.spaceM),
          Text(
            AppStrings.chatEmpty,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.darkMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.darkSurface,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: AppSizes.spaceL),
            CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.darkAccent1,
              child: const Icon(
                Icons.person_rounded,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: AppSizes.spaceM),
            const Text(
              'User',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSizes.spaceXL),
            _buildDrawerItem(
              icon: Icons.chat_rounded,
              title: 'Chat',
              onTap: () => context.go('/chat'),
            ),
            _buildDrawerItem(
              icon: Icons.mic_rounded,
              title: 'Voice',
              onTap: () => context.push('/voice'),
            ),
            _buildDrawerItem(
              icon: Icons.apps_rounded,
              title: 'Tools',
              onTap: () => context.push('/tools'),
            ),
            _buildDrawerItem(
              icon: Icons.person_rounded,
              title: 'Profile',
              onTap: () => context.push('/profile'),
            ),
            _buildDrawerItem(
              icon: Icons.settings_rounded,
              title: 'Settings',
              onTap: () => context.push('/settings'),
            ),
            const Spacer(),
            _buildDrawerItem(
              icon: Icons.info_rounded,
              title: 'About',
              onTap: () => context.push('/about'),
            ),
            const SizedBox(height: AppSizes.spaceL),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  void _showMessageOptions(BuildContext context, String messageId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.copy_rounded),
              title: const Text(AppStrings.copyMessage),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.share_rounded),
              title: const Text(AppStrings.shareMessage),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.favorite_rounded),
              title: const Text(AppStrings.favoriteMessage),
              onTap: () {
                ref.read(chatMessagesProvider.notifier).toggleFavorite(messageId);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_rounded),
              title: const Text(AppStrings.deleteMessage),
              onTap: () {
                ref.read(chatMessagesProvider.notifier).deleteMessage(messageId);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
