import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Color? iconColor = Colors.black;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override

  /// Build a custom bottom navigation bar with the following items in order:
  ///
  /// 1. Chat
  /// 2. Transaction
  /// 3. Dashboard
  /// 4. Card
  /// 5. Settings
  ///
  /// The selected item is determined by [selectedIndex].
  /// The callback function when an item is tapped is [onItemTapped].
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.chat_bubble_outline_outlined,
            color: iconColor,
            size: 28,
          ),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.swap_horiz_outlined,
            color: iconColor,
            size: 28,
          ),
          label: 'Transaction',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.dashboard_outlined,
            color: iconColor,
            size: 28,
          ),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.credit_card_outlined,
            color: iconColor,
            size: 28,
          ),
          label: 'Card',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.settings_outlined,
            color: iconColor,
            size: 28,
          ),
          label: 'Settings',
        ),
      ],
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      type: BottomNavigationBarType.fixed,
    );
  }
}
