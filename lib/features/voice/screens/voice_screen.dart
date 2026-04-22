import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_sizes.dart';
import '../../shared/widgets/animated_gradient_bg.dart';
import '../../shared/widgets/glass_container.dart';

class VoiceScreen extends StatefulWidget {
  const VoiceScreen({super.key});

  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  bool _isListening = false;
  String _statusText = AppStrings.voiceIdle;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleListening() {
    setState(() {
      _isListening = !_isListening;
      if (_isListening) {
        _statusText = AppStrings.voiceListening;
        _pulseController.repeat();
      } else {
        _statusText = AppStrings.voiceIdle;
        _pulseController.stop();
      }
    });
  }

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
                        'Voice Assistant',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Waveform Placeholder
              Container(
                height: 100,
                margin: const EdgeInsets.symmetric(horizontal: AppSizes.paddingXL),
                child: _isListening
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: List.generate(
                          20,
                          (index) => Container(
                            width: 4,
                            height: 20 + (index % 5) * 10,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              gradient: AppColors.userMessageGradient,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          )
                              .animate(onPlay: (controller) => controller.repeat(reverse: true))
                              .scaleY(
                                duration: (500 + index * 50).ms,
                                begin: 0.5,
                                end: 1.5,
                              ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              
              const SizedBox(height: AppSizes.spaceXXL),
              
              // Mic Button
              GestureDetector(
                onTap: _toggleListening,
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // Pulse Ring
                        if (_isListening)
                          Container(
                            width: 120 + (_pulseController.value * 40),
                            height: 120 + (_pulseController.value * 40),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.darkAccent1.withOpacity(1 - _pulseController.value),
                                width: 2,
                              ),
                            ),
                          ),
                        
                        // Mic Button
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            gradient: AppColors.userMessageGradient,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.darkAccent1.withOpacity(0.5),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Icon(
                            _isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
                            size: 48,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              
              const SizedBox(height: AppSizes.spaceXL),
              
              // Status Text
              Text(
                _statusText,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              const Spacer(),
              
              // Transcript Area
              GlassContainer(
                margin: const EdgeInsets.all(AppSizes.paddingXL),
                padding: const EdgeInsets.all(AppSizes.paddingL),
                child: const SizedBox(
                  width: double.infinity,
                  height: 100,
                  child: Center(
                    child: Text(
                      'Your speech will appear here...',
                      style: TextStyle(
                        color: AppColors.darkMuted,
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: AppSizes.spaceXL),
            ],
          ),
        ),
      ),
    );
  }
}
