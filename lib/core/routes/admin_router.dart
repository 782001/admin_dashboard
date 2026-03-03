import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_shell.dart';
import '../../features/projects/presentation/pages/projects_page.dart';
import '../../features/experience/presentation/pages/experience_page.dart';
import '../../features/skills/presentation/pages/skills_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';

import '../../features/education/presentation/pages/education_page.dart';
import '../../features/contacts/presentation/pages/contacts_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

class SupabaseAuthListenable extends ChangeNotifier {
  SupabaseAuthListenable() {
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      notifyListeners();
    });
  }
}

class AdminRouter {
  static final authListenable = SupabaseAuthListenable();

  static final router = GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    refreshListenable: authListenable,
    redirect: (context, state) {
      final session = Supabase.instance.client.auth.currentSession;
      final isLoggingIn = state.matchedLocation == '/login';

      if (session == null && !isLoggingIn) {
        return '/login';
      }
      if (session != null && isLoggingIn) {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => DashboardShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: '/projects',
            builder: (context, state) => const ProjectsPage(),
          ),
          GoRoute(
            path: '/experience',
            builder: (context, state) => const ExperiencePage(),
          ),
          GoRoute(
            path: '/skills',
            builder: (context, state) => const SkillsPage(),
          ),
          GoRoute(
            path: '/education',
            builder: (context, state) => const EducationPage(),
          ),
          GoRoute(
            path: '/contacts',
            builder: (context, state) => const ContactsPage(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
    ],
  );
}
