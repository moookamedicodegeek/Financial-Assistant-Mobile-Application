import 'package:flutter/material.dart';

class BuildListTile extends StatelessWidget {
  final BuildContext context;
  final IconData icon;
  final String title;
  final String subtitle;
  final Function onTap;

  const BuildListTile({
    super.key,
    required this.context,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: Theme.of(context).colorScheme.tertiary,
          width: 1,
        ),
      ),
      leading: Icon(
        icon,
        size: 40,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () => onTap(),
    );
  }
}
