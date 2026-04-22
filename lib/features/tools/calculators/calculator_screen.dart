import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_sizes.dart';
import '../../shared/widgets/animated_gradient_bg.dart';
import '../../shared/widgets/glass_container.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _expression = '';

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _display = '0';
        _expression = '';
      } else if (value == '=') {
        // Simple evaluation (in production, use math_expressions package)
        _expression = _display;
      } else {
        if (_display == '0') {
          _display = value;
        } else {
          _display += value;
        }
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
                        AppStrings.calculatorTitle,
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
              
              // Display
              Expanded(
                child: GlassContainer(
                  margin: const EdgeInsets.all(AppSizes.paddingM),
                  padding: const EdgeInsets.all(AppSizes.paddingXL),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (_expression.isNotEmpty)
                        Text(
                          _expression,
                          style: const TextStyle(
                            fontSize: 20,
                            color: AppColors.darkMuted,
                          ),
                        ),
                      const SizedBox(height: AppSizes.spaceM),
                      Text(
                        _display,
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Buttons
              Padding(
                padding: const EdgeInsets.all(AppSizes.paddingM),
                child: Column(
                  children: [
                    _buildButtonRow(['7', '8', '9', '÷']),
                    const SizedBox(height: AppSizes.spaceS),
                    _buildButtonRow(['4', '5', '6', '×']),
                    const SizedBox(height: AppSizes.spaceS),
                    _buildButtonRow(['1', '2', '3', '-']),
                    const SizedBox(height: AppSizes.spaceS),
                    _buildButtonRow(['C', '0', '=', '+']),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtonRow(List<String> buttons) {
    return Row(
      children: buttons.map((button) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: _CalcButton(
              label: button,
              onPressed: () => _onButtonPressed(button),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _CalcButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _CalcButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isOperator = ['÷', '×', '-', '+', '='].contains(label);
    
    return GestureDetector(
      onTap: onPressed,
      child: GlassContainer(
        height: 70,
        gradient: isOperator ? AppColors.userMessageGradient : null,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: isOperator ? Colors.white : null,
            ),
          ),
        ),
      ),
    );
  }
}
