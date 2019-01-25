import 'package:flutter/material.dart';
import 'package:meetup_animations/main.dart';
import 'package:meetup_animations/myheader.dart';

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          MyHeader(),
          Expanded(
            child: BodyWidget(),
          )
        ],
      ),
    );
  }
}

class BodyWidget extends StatefulWidget {
  @override
  _BodyWidgetState createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
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
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: _buildLibrarySegment(),
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: _buildSelectedSegment()),
      ],
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
            itemBuilder: (context, index) => ExerciseListItem(
                  exercise: selectedExercises[index],
                  onTap: (e) {},
                ),
            itemCount: selectedExercises.length,
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
            itemBuilder: (context, index) => ExerciseListItem(
                  exercise: exercises[index],
                  onTap: _onItemTap,
                ),
            itemCount: exercises.length,
          ),
        )
      ],
    );
  }

  _onItemTap(Exercise exercise) {
    setState(() {
      exercises.remove(exercise);
      selectedExercises.add(exercise);
    });
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
  final Function(Exercise) onTap;

  const ExerciseListItem(
      {Key key, @required this.exercise, @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(exercise),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            Image.asset(
              'assets/biceps.png',
              width: 40,
              height: 40,
            ),
            SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    exercise.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ),
                      );
                    }).toList(),
                  )
                ],
              ),
            ),
            Icon(
              Icons.add_circle_outline,
              color: lightBlue,
            )
          ],
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
