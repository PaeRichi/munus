import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../ui/screens/home/home_screen.dart';
import '../../ui/screens/splash/splash_screen.dart';
import '../../ui/screens/celebration_list/celebration_list_screen.dart';
import '../../ui/screens/celebration/celebration_screen.dart';
import '../../ui/screens/qr/assembly_qr_screen.dart';
import '../../ui/screens/about/about_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    ),
    GoRoute(
      path: '/category/:categoryId',
      builder: (context, state) {
        final categoryId = state.pathParameters['categoryId']!;
        return CelebrationListScreen(categoryId: categoryId);
      },
    ),
    GoRoute(
      path: '/category/:categoryId/celebration',
      builder: (context, state) {
        final categoryId = state.pathParameters['categoryId']!;
        final extra = state.extra as Map<String, String?>;
        return CelebrationScreen(
          categoryId: categoryId,
          celebrationMeta: Map<String, String>.fromEntries(
            extra.entries
                .where((e) => e.value != null)
                .map((e) => MapEntry(e.key, e.value!)),
          ),
        );
      },
    ),
    GoRoute(
      path: '/qr',
      builder: (context, state) {
        final extra = state.extra as Map<String, String>;
        return AssemblyQrScreen(
          url: extra['url']!,
          celebrationTitle: extra['title']!,
        );
      },
    ),
    GoRoute(
      path: '/about',
      builder: (context, state) => const AboutScreen(),
    ),
  ],
);