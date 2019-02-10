import 'package:flutter/material.dart';

class FadeRoute<T> extends PageRouteBuilder<T> {
  FadeRoute(Widget child)
      : super(
          pageBuilder: (context, animation1, animation2) => child,
          transitionsBuilder: (context, animation1, animation2, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: Offset(0, 0.1),
                end: Offset.zero,
              ).animate(animation1),
              child: FadeTransition(
                opacity: animation1,
                child: child,
              ),
            );
          },
          transitionDuration: Duration(milliseconds: 300),
        );
}
