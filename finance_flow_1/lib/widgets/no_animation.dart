import 'package:flutter/material.dart';

class NoAnimationPageRoute extends PageRouteBuilder {
  final Widget page;

  NoAnimationPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: Duration.zero, // No transition duration
          reverseTransitionDuration: Duration.zero, // No reverse transition
        );
}
