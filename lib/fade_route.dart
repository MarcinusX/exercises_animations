import 'package:flutter/material.dart';

class FadeRoute<T> extends PageRouteBuilder<T> {
  FadeRoute(Widget child)
      : super(
          pageBuilder: (context, animation1, animation2) => child,
          transitionsBuilder: (context, animation1, animation2, child) {
            return FadeTransition(
              opacity: animation1,
              child: child,
            );
          },
          transitionDuration: Duration(milliseconds: 500),
        );
}
