import 'package:finance_flow_1/route_manager.dart';
import 'package:finance_flow_1/widgets/nav_bar.dart';
import 'package:flutter/material.dart';

class BaseScreen extends StatefulWidget {
  final Widget body;
  final String title;
  final Widget? floatingButton;

  const BaseScreen(
      {super.key,
      required this.body,
      required this.title,
      this.floatingButton});

  @override
  BaseScreenState createState() => BaseScreenState();
}

class BaseScreenState extends State<BaseScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the corresponding route based on the selected index
    switch (index) {
      case 0: // Dashboard
        Navigator.pushReplacementNamed(context, RouteManager.chat);
        break;
      case 1: // Chat
        Navigator.pushReplacementNamed(context, RouteManager.transactionsPage);
        break;
      case 2: // Transactions
        Navigator.pushReplacementNamed(context, RouteManager.dashboard);
        break;
      case 3: // Virtual Card
        Navigator.pushReplacementNamed(context, RouteManager.virtualCard);
        break;
      case 4: // Settings
        Navigator.pushReplacementNamed(context, RouteManager.settingsPage);
        break;
      default:
        Navigator.pushReplacementNamed(context, RouteManager.pageNotFound);
    }
  }

  @override

  /// Builds a base screen widget with a title, body, and bottom navigation bar.
  ///
  /// The title is displayed in the app bar at the top of the screen. The body is
  /// the main content of the screen, and is displayed below the app bar. The
  /// bottom navigation bar is displayed at the bottom of the screen, and is used
  /// to navigate between different parts of the app. The currently selected index
  /// is stored in the `_selectedIndex` field, and is used to determine which item
  /// in the bottom navigation bar is currently selected.
  ///
  /// The `onItemTapped` callback is called when an item in the bottom navigation
  /// bar is tapped. It takes an integer `index` as an argument, which is the index
  /// of the tapped item in the bottom navigation bar. The default implementation
  /// of this callback sets the `_selectedIndex` field to the given index, and
  /// navigates to the corresponding route based on the index.
  ///
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
        child: widget.body,
      ),
      floatingActionButton: widget.floatingButton,
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
