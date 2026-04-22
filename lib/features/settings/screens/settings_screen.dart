import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_sizes.dart';
import '../../shared/widgets/animated_gradient_bg.dart';
import '../../shared/widgets/glass_container.dart';
import '../providers/settings_provider.dart';
import '../../chat/providers/chat_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final voiceSpeed = ref.watch(voiceSpeedProvider);
    final voicePitch = ref.watch(voicePitchProvider);
    final offlineMode = ref.watch(offlineModeProvider);
    final notificationsEnabled = ref.watch(notificationsEnabledProvider);
    
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
                        AppStrings.settingsTitle,
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
                  padding: const EdgeInsets.all(AppSizes.paddingM),
                  children: [
                    GlassContainer(
                      padding: const EdgeInsets.all(AppSizes.paddingL),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            AppStrings.settingsTheme,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: AppSizes.spaceM),
                          SegmentedButton<ThemeMode>(
                            segments: const [
                              ButtonSegment(
                                value: ThemeMode.light,
                                label: Text(AppStrings.settingsThemeLight),
                                icon: Icon(Icons.light_mode_rounded),
                              ),
                              ButtonSegment(
                                value: ThemeMode.dark,
                                label: Text(AppStrings.settingsThemeDark),
                                icon: Icon(Icons.dark_mode_rounded),
                              ),
                              ButtonSegment(
                                value: ThemeMode.system,
                                label: Text(AppStrings.settingsThemeSystem),
                                icon: Icon(Icons.auto_mode_rounded),
                              ),
                            ],
                            selected: {themeMode},
                            onSelectionChanged: (Set<ThemeMode> newSelection) {
                              ref.read(themeModeProvider.notifier).setThemeMode(newSelection.first);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSizes.spaceM),
                    GlassContainer(
                      padding: const EdgeInsets.all(AppSizes.paddingL),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            AppStrings.settingsVoice,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: AppSizes.spaceM),
                          Text(
                            '${AppStrings.settingsVoiceSpeed}: ${voiceSpeed.toStringAsFixed(1)}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          Slider(
                            value: voiceSpeed,
                            min: 0.1,
                            max: 1.0,
                            divisions: 9,
                            onChanged: (value) {
                              ref.read(voiceSpeedProvider.notifier).setSpeed(value);
                            },
                          ),
                          const SizedBox(height: AppSizes.spaceM),
                          Text(
                            '${AppStrings.settingsVoicePitch}: ${voicePitch.toStringAsFixed(1)}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          Slider(
                            value: voicePitch,
                            min: 0.5,
                            max: 2.0,
                            divisions: 15,
                            onChanged: (value) {
                              ref.read(voicePitchProvider.notifier).setPitch(value);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSizes.spaceM),
                    GlassContainer(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingL,
                        vertical: AppSizes.paddingS,
                      ),
                      child: SwitchListTile(
                        title: const Text(AppStrings.settingsOfflineMode),
                        value: offlineMode,
                        onChanged: (value) {
                          ref.read(offlineModeProvider.notifier).setMode(value);
                        },
                      ),
                    ),
                    const SizedBox(height: AppSizes.spaceM),
                    GlassContainer(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingL,
                        vertical: AppSizes.paddingS,
                      ),
                      child: SwitchListTile(
                        title: const Text(AppStrings.settingsNotifications),
                        value: notificationsEnabled,
                        onChanged: (value) {
                          ref.read(notificationsEnabledProvider.notifier).setEnabled(value);
                        },
                      ),
                    ),
                    const SizedBox(height: AppSizes.spaceM),
                    GlassContainer(
                      child: ListTile(
                        leading: const Icon(Icons.delete_outline_rounded),
                        title: const Text(AppStrings.settingsClearHistory),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text(AppStrings.settingsClearHistory),
                              content: const Text('Are you sure you want to clear all chat history?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(AppStrings.actionCancel),
                                ),
                                TextButton(
                                  onPressed: () {
                                    ref.read(chatMessagesProvider.notifier).clearHistory();
                                    Navigator.pop(context);
                                  },
                                  child: const Text(AppStrings.actionDelete),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: AppSizes.spaceM),
                    GlassContainer(
                      child: ListTile(
                        leading: const Icon(Icons.info_outline_rounded),
                        title: const Text(AppStrings.settingsAbout),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => context.push('/about'),
                      ),
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
