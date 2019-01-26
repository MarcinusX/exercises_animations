import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meetup_animations/list_page.dart';
import 'package:meetup_animations/main.dart';

class DetailsPage extends StatefulWidget {
  final Exercise exercise;

  const DetailsPage({Key key, this.exercise}) : super(key: key);

  @override
  DetailsPageState createState() {
    return new DetailsPageState();
  }
}

class DetailsPageState extends State<DetailsPage> {
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    child: Icon(Icons.arrow_back, color: lightBlue),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  Icon(Icons.add_circle_outline, color: lightBlue),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                widget.exercise.name,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 300,
              child: PageView(
                controller: pageController,
                children: <Widget>[
                  Image.asset('assets/biceps.png'),
                  Image.asset('assets/biceps.png'),
                  Image.asset('assets/biceps.png'),
                ],
              ),
            ),
            Divider(
              color: Colors.grey,
              height: 28,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'MUSCLES INVOLVED',
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 12),
              ),
            ),
            SizedBox(
              height: 32,
              child: ListView(
                padding: EdgeInsets.only(left: 16),
                scrollDirection: Axis.horizontal,
                children: widget.exercise.tags.map(
                  (tag) {
                    double opacity = widget.exercise.tags.first == tag ? 1 : .5;
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: lightBlue.withOpacity(opacity),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              tag,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
            Divider(
              color: Colors.grey,
              height: 28,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'ABOUT',
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas quis elit mauris. Sed dictum accumsan ligula non scelerisque. Nam nibh nulla, tincidunt ut diam quis, porttitor ultrices felis. Duis turpis libero, aliquet eget fermentum id, sollicitudin vitae tellus. Aliquam felis lorem, pretium vel fringilla sed, placerat eu purus. Maecenas in porttitor eros. Suspendisse pulvinar, nulla id cursus gravida, nibh lectus ornare lorem, ac pulvinar sapien massa euismod velit. Praesent rhoncus ac orci mollis vehicula. Praesent hendrerit massa sed eros porttitor malesuada.'),
            )
          ],
        ),
      ),
    );
  }
}
