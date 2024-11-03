import 'package:finance_flow_1/route_manager.dart';
import 'package:finance_flow_1/services/user_auth.dart';
import 'package:finance_flow_1/widgets/build_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finance_flow_1/widgets/base_screen.dart';
import 'package:finance_flow_1/theme/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  final UserAuth _authService = UserAuth();

  SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Settings',
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Material(
              elevation: 5,
              shadowColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.5),
              child: BuildListTile(
                  context: context,
                  icon: Icons.person_outline,
                  title: 'View Profile',
                  subtitle: 'View details about your account',
                  onTap: () {
                    Navigator.pushNamed(context, RouteManager.profilePage);
                  }),
            ),
            const SizedBox(height: 30),
            Material(
              elevation: 5,
              shadowColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.5),
              child: BuildListTile(
                  context: context,
                  icon: Icons.settings_display_outlined,
                  title: 'Display mode',
                  subtitle: 'Change display theme',
                  onTap: () {
                    _showThemeChangeDialog(context);
                  }),
            ),
            const SizedBox(height: 30),
            Material(
              elevation: 5,
              shadowColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.5),
              child: BuildListTile(
                  context: context,
                  icon: Icons.logout_outlined,
                  title: 'Logout',
                  subtitle: 'Logout of the application',
                  onTap: () {
                    _showLogoutDialog(context);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: const Text(
            'Logout',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontSize: 18,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: 18),
              ),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('Logout',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontSize: 18)),
              onPressed: () {
                _authService.signOut();
                Navigator.of(context).pushReplacementNamed(RouteManager.login);
              },
            ),
          ],
        );
      },
    );
  }

  void _showThemeChangeDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final themeProvider =
            Provider.of<ThemeProvider>(context, listen: false);
        final currentTheme =
            themeProvider.themeData.brightness == Brightness.light
                ? 'Dark'
                : 'Light';

        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: const Text('Change Theme',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text(
            'Apply $currentTheme theme?',
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontSize: 18,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: 18,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text(
                'Apply',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: 18,
                ),
              ),
              onPressed: () {
                themeProvider.toggleTheme(); // Toggle the theme
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );
  }
}
