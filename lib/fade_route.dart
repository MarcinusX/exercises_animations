import 'package:flutter/material.dart';
import 'package:meetup_animations/details_page.dart';

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
          transitionDuration: Duration(milliseconds: 300),
        );
}
