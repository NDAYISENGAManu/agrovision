import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/dashboard/presentation/pages/home_page.dart';
import '../../features/farms/presentation/pages/farms_list_page.dart';
import '../../features/farms/presentation/pages/farm_detail_page.dart';
import '../../features/diagnosis/presentation/pages/diagnosis_page.dart';
import '../../features/diagnosis/presentation/pages/diagnosis_result_page.dart';
import '../../features/marketplace/presentation/pages/marketplace_page.dart';
import '../../features/weather/presentation/pages/weather_page.dart';
import '../../features/learning/presentation/pages/learning_page.dart';
import '../../features/forum/presentation/pages/forum_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      // Auth Routes
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      
      // Main App Routes
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      
      // Farms
      GoRoute(
        path: '/farms',
        name: 'farms',
        builder: (context, state) => const FarmsListPage(),
      ),
      GoRoute(
        path: '/farms/:id',
        name: 'farm-detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return FarmDetailPage(farmId: id);
        },
      ),
      
      // Diagnosis
      GoRoute(
        path: '/diagnosis',
        name: 'diagnosis',
        builder: (context, state) => const DiagnosisPage(),
      ),
      GoRoute(
        path: '/diagnosis/result',
        name: 'diagnosis-result',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return DiagnosisResultPage(diagnosis: extra);
        },
      ),
      
      // Marketplace
      GoRoute(
        path: '/marketplace',
        name: 'marketplace',
        builder: (context, state) => const MarketplacePage(),
      ),
      
      // Weather
      GoRoute(
        path: '/weather',
        name: 'weather',
        builder: (context, state) => const WeatherPage(),
      ),
      
      // Learning
      GoRoute(
        path: '/learning',
        name: 'learning',
        builder: (context, state) => const LearningPage(),
      ),
      
      // Forum
      GoRoute(
        path: '/forum',
        name: 'forum',
        builder: (context, state) => const ForumPage(),
      ),
      
      // Profile
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
});
