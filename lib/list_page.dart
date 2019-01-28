import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meetup_animations/details_page.dart';
import 'package:meetup_animations/exercise.dart';
import 'package:meetup_animations/exercise_list_item.dart';
import 'package:meetup_animations/fade_route.dart';
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
                  emptySpace: MediaQuery.of(context).size.width *
                      0.2 *
                      _navigationController.value,
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
    await Navigator.of(context)
        .push(FadeRoute(DetailsPage(exercise: exercise)));
    _navigationController.reverse();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  }
}

class BodyWidget extends StatefulWidget {
  final Function(Exercise) goToNextPage;
  final double emptySpace;

  const BodyWidget({Key key, this.goToNextPage, this.emptySpace = 0})
      : super(key: key);

  @override
  _BodyWidgetState createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> with TickerProviderStateMixin {
  AnimationController _transitionController;
  Animation<Rect> _rectAnimation;
  final GlobalKey lastItemKey = RectGetter.createGlobalKey();
  OverlayEntry transitionOverlayEntry;

  List<Exercise> exercises = [
    Exercise('Pullups', ['Lats', 'Biceps'], 'i1.png'),
    Exercise('Leg Press', ['Quadriceps', 'Hamstrings'], 'i2.png'),
    Exercise('Dumbbell Bench Press', ['Chest', 'Triceps'], 'i3.png'),
    Exercise('Deadlift', ['Hamstrings', 'Lower Back', 'Quadriceps', 'Glutes'],
        'i4.png'),
    Exercise(
        'Bent Over Barbell Row', ['Lats', 'Middle Back', 'Deltoids'], 'i5.png'),
    Exercise('T-Bar Row', ['Middle Back', 'Lats'], 'i6.png'),
    Exercise('Pushups', ['Chest', 'Triceps'], 'i7.png'),
    Exercise(
        'Bent Over Two-Arm Long Bar Row', ['Middle Back', 'Lats'], 'i8.png'),
    Exercise('Dumbbel Bench Press', ['Chest', 'Triceps'], 'i9.png'),
    Exercise('Wide-Grip Barbell Curl', ['Chest', 'Deltoids'], 'i10.png'),
    Exercise('Decline Dumbbel Flyes', ['Chest', 'Deltoids'], 'i11.png'),
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
          child: _buildSelectedSegment(),
        ),
      ],
    );
  }

  _onItemTap(Exercise exercise, Rect rect) {
    int indexOfExercise = exercises.indexOf(exercise);
    setState(() {
      exercises[indexOfExercise] = null;
    });

    Rect lastContainerRect = RectGetter.getRectFromKey(lastItemKey);
    Rect endRect = Rect.fromLTWH(
      lastContainerRect?.left ?? MediaQuery.of(context).size.width * 0.8,
      lastContainerRect?.top ?? MediaQuery.of(context).size.height,
      rect.size.width,
      rect.size.height,
    );

    _rectAnimation = RectTween(
      begin: rect,
      end: endRect,
    ).animate(CurvedAnimation(
      parent: _transitionController,
      curve: Curves.easeInOut,
    ));

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
                return RectGetter(
                  key: lastItemKey,
                  child: Container(),
                );
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
                        exercise,
                        RectGetter.getRectFromKey(globalKey),
                      ),
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
