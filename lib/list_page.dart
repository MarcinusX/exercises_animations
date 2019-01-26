import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meetup_animations/details_page.dart';
import 'package:meetup_animations/fade_route.dart';
import 'package:meetup_animations/main.dart';
import 'package:meetup_animations/myheader.dart';
import 'package:rect_getter/rect_getter.dart';

class ListPage extends StatefulWidget {
  @override
  ListPageState createState() {
    return new ListPageState();
  }
}

class ListPageState extends State<ListPage>
    with SingleTickerProviderStateMixin {
  AnimationController _navigationController;

  @override
  void initState() {
    super.initState();
    _navigationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    _navigationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _navigationController,
        builder: (context, child) {
          return Column(
            children: <Widget>[
              Transform.translate(
                offset: Offset(0, -200 * _navigationController.value),
                child: MyHeader(),
              ),
              Expanded(
                child: BodyWidget(
                  goToNextPage: (ex) => _goToDetails(ex),
                  emptySpace: MediaQuery.of(context).size.width*0.2*_navigationController.value,
                ),
              )
            ],
          );
        },
      ),
    );
  }

  void _goToDetails(Exercise exercise) async {
    _navigationController.forward();
//    await Future.delayed(Duration(milliseconds: 150));
    await Navigator.of(context)
        .push(FadeRoute(DetailsPage(exercise: exercise)));
    _navigationController.reverse();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  }
}

class BodyWidget extends StatefulWidget {
  final Function(Exercise) goToNextPage;
  final double emptySpace;

  const BodyWidget({Key key, this.goToNextPage, this.emptySpace}) : super(key: key);

  @override
  _BodyWidgetState createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> with TickerProviderStateMixin {
  AnimationController _transitionController;
  Animation<Rect> _rectAnimation;
  final GlobalKey lastItemKey = RectGetter.createGlobalKey();
  OverlayEntry transitionOverlayEntry;

  List<Exercise> exercises = [
    Exercise('Pullups', ['Lats', 'Biceps']),
    Exercise('Leg Press', ['Quadriceps', 'Hamstrings']),
    Exercise('Dumbbell Bench Press', ['Chest', 'Triceps']),
    Exercise('Deadlift', ['Hamstrings', 'Lower Back', 'Quadriceps', 'Glutes']),
    Exercise('Bent Over Barbell Row', ['Lats', 'Middle Back', 'Deltoids']),
    Exercise('T-Bar Row', ['Middle Back', 'Lats']),
    Exercise('Pushups', ['Chest', 'Triceps']),
    Exercise('Bent Over Two-Arm Long Bar Row', ['Middle Back', 'Lats']),
    Exercise('Dumbbel Bench Press', ['Chest', 'Triceps']),
    Exercise('Wide-Grip Barbell Curl', ['Chest', 'Deltoids']),
    Exercise('Decline Dumbbel Flyes', ['Chest', 'Deltoids']),
  ];
  List<Exercise> selectedExercises = [];

  @override
  void initState() {
    super.initState();
    _transitionController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _transitionController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        transitionOverlayEntry?.remove();
      }
    });
  }

  @override
  void dispose() {
    _transitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: _buildLibrarySegment(),
        ),
        SizedBox(width: widget.emptySpace),
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: _buildSelectedSegment()),
      ],
    );
  }

  _onItemTap(Exercise exercise, Rect rect) {
    int indexOfExercise = exercises.indexOf(exercise);
    setState(() {
      exercises[indexOfExercise] = null;
      exercises.remove(exercise);
    });

    Rect lastContainerRect = RectGetter.getRectFromKey(lastItemKey);
    Rect endRect = Rect.fromLTWH(lastContainerRect.left, lastContainerRect.top,
        rect.size.width, rect.size.height);

    _rectAnimation = RectTween(
      begin: rect,
      end: endRect,
    ).animate(CurvedAnimation(
        parent: _transitionController, curve: Curves.easeInOut));

    transitionOverlayEntry = _createOverlayEntry(exercise);
    Overlay.of(context).insert(transitionOverlayEntry);

    _transitionController.forward(from: 0).then((_) {
      setState(() {
        selectedExercises.add(exercise);
        exercises.removeAt(indexOfExercise);
      });
    });
  }

  OverlayEntry _createOverlayEntry(Exercise exercise) {
    return OverlayEntry(
      builder: (context) {
        return AnimatedBuilder(
          animation: _rectAnimation,
          builder: (context, child) {
            return Positioned(
              top: _rectAnimation.value.top,
              left: _rectAnimation.value.left,
              child: SizedBox(
                height: _rectAnimation.value.height + 1,
                width: _rectAnimation.value.width,
                child: ExerciseListItem(exercise: exercise),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSelectedSegment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _listTitle("SELECTED"),
        Expanded(
          child: ListView.separated(
            separatorBuilder: _dividerBuilder,
            padding: EdgeInsets.all(0),
            itemBuilder: (context, index) {
              if (index == selectedExercises.length) {
                return RectGetter(key: lastItemKey, child: Container());
              }
              return ExerciseListItem(
                exercise: selectedExercises[index],
              );
            },
            itemCount: selectedExercises.length + 1,
          ),
        )
      ],
    );
  }

  Widget _buildLibrarySegment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _listTitle("LIBRARY"),
        Expanded(
          child: ListView.separated(
            separatorBuilder: _dividerBuilder,
            padding: EdgeInsets.all(0),
            itemBuilder: (context, index) {
              Exercise exercise = exercises[index];
              if (exercise == null) {
                return AnimatedBuilder(
                  animation: _transitionController,
                  builder: (context, child) {
                    return SizedBox(
                      height: (1 - _transitionController.value) *
                          _rectAnimation.value.height,
                    );
                  },
                );
              }
              var globalKey = RectGetter.createGlobalKey();
              return RectGetter(
                key: globalKey,
                child: ExerciseListItem(
                  exercise: exercise,
                  onPlusTap: () => _onItemTap(
                      exercise, RectGetter.getRectFromKey(globalKey)),
                  onTap: () => widget.goToNextPage(exercise),
                ),
              );
            },
            itemCount: exercises.length,
          ),
        )
      ],
    );
  }

  Widget _listTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        title,
        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _dividerBuilder(BuildContext context, int index) {
    return Divider(
      color: Colors.grey,
      indent: 16,
    );
  }
}

class ExerciseListItem extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onTap;
  final VoidCallback onPlusTap;

  const ExerciseListItem({
    Key key,
    @required this.exercise,
    this.onTap,
    this.onPlusTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: <Widget>[
              Hero(
                tag: exercise.name,
                child: Image.asset(
                  'assets/biceps.png',
                  width: 40,
                  height: 40,
                ),
              ),
              SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      exercise.name,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: exercise.tags.map((tag) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              tag,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ),
                        );
                      }).toList(),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: onPlusTap,
                child: Icon(
                  Icons.add_circle_outline,
                  color: lightBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Exercise {
  final String name;
  final List<String> tags;

  Exercise(this.name, this.tags);
}
