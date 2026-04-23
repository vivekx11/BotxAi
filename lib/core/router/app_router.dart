// import all the files 

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/welcome_screen.dart';
import '../../features/chat/screens/chat_screen.dart';
import '../../features/voice/screens/voice_screen.dart';
import '../../features/tools/screens/tools_dashboard.dart';
import '../../features/tools/calculators/calculator_screen.dart';
import '../../features/tools/notes/notes_screen.dart';
import '../../features/tools/weather/weather_screen.dart';
import '../../features/tools/translator/screens/translator_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/settings/screens/about_screen.dart';
import '../../features/settings/screens/profile_screen.dart';
// final phase 
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SplashScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/welcome',
        name: 'welcome',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const WelcomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/chat',
        name: 'chat',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ChatScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/voice',
        name: 'voice',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const VoiceScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: '/tools',
        name: 'tools',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ToolsDashboard(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation),
                child: child,
              ),
            );
          },
        ),
      ),
      GoRoute(
        path: '/calculator',
        name: 'calculator',
        pageBuilder: (context, state) => _slideUpTransition(state, const CalculatorScreen()),
      ),
      GoRoute(
        path: '/notes',
        name: 'notes',
        pageBuilder: (context, state) => _slideUpTransition(state, const NotesScreen()),
      ),
      GoRoute(
        path: '/weather',
        name: 'weather',
        pageBuilder: (context, state) => _slideUpTransition(state, const WeatherScreen()),
      ),
      GoRoute(
        path: '/translator',
        name: 'translator',
        pageBuilder: (context, state) => _slideUpTransition(state, const TranslatorScreen()),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        pageBuilder: (context, state) => _slideUpTransition(state, const SettingsScreen()),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        pageBuilder: (context, state) => _slideUpTransition(state, const ProfileScreen()),
      ),
      GoRoute(
        path: '/about',
        name: 'about',
        pageBuilder: (context, state) => _slideUpTransition(state, const AboutScreen()),
      ),
    ],
  );
});

CustomTransitionPage _slideUpTransition(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
