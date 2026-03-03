import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';

class DashboardShell extends StatelessWidget {
  final Widget child;

  const DashboardShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final path = GoRouterState.of(context).matchedLocation;

    int getSelectedIndex() {
      if (path.startsWith('/projects')) return 1;
      if (path.startsWith('/experience')) return 2;
      if (path.startsWith('/skills')) return 3;
      if (path.startsWith('/education')) return 4;
      if (path.startsWith('/contacts')) return 5;
      if (path.startsWith('/settings')) return 6;
      return 0; // Overview/Home
    }

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: MediaQuery.of(context).size.width >= 800,
            selectedIndex: getSelectedIndex(),
            onDestinationSelected: (index) {
              switch (index) {
                case 0:
                  context.go('/');
                  break;
                case 1:
                  context.go('/projects');
                  break;
                case 2:
                  context.go('/experience');
                  break;
                case 3:
                  context.go('/skills');
                  break;
                case 4:
                  context.go('/education');
                  break;
                case 5:
                  context.go('/contacts');
                  break;
                case 6:
                  context.go('/settings');
                  break;
              }
            },
            leading: Padding(
              padding: const EdgeInsets.only(bottom: 24.0, top: 16.0),
              child: Icon(
                Icons.dashboard,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            trailing: Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: IconButton(
                    icon: const Icon(Icons.logout),
                    tooltip: 'Logout',
                    onPressed: () {
                      context.read<AuthCubit>().signOut();
                    },
                  ),
                ),
              ),
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text('Overview'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.work),
                label: Text('Projects'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.timeline),
                label: Text('Experience'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.star),
                label: Text('Skills'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.school),
                label: Text('Education'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.contact_mail),
                label: Text('Contacts'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                label: Text('Settings'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }
}
