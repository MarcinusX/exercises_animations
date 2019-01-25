
import 'package:flutter/material.dart';
import 'package:meetup_animations/main.dart';

class MyHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF242944), Color(0xFF354190)],
          begin: Alignment.bottomRight,
          end: Alignment(-1.2, -1.2),
        ),
      ),
      height: 240,
      child: Padding(
        padding: EdgeInsets.all(16).add(
          EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Icon(Icons.close, color: lightBlue, size: 28),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Text(
                'Next',
                style: TextStyle(color: lightBlue, fontSize: 16),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Add Exercises',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Workout creation',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 8),
                  Text('Search', style: TextStyle(color: Colors.grey),),
                  Spacer(),
                  Icon(Icons.tune, color: lightBlue,)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
