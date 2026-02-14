import 'package:flutter/material.dart';

PageRoute<T> fadeSlideRoute<T>({
  required Widget child,
  Duration duration = const Duration(milliseconds: 280),
  double slideOffset = 0.03,
}) {
  return PageRouteBuilder<T>(
    pageBuilder: (_, __, ___) => child,
    transitionsBuilder: (_, animation, __, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, slideOffset),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child,
        ),
      );
    },
    transitionDuration: duration,
  );
}
