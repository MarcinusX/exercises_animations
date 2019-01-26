import 'package:flutter/material.dart';
import 'package:meetup_animations/exercise.dart';
import 'package:meetup_animations/main.dart';

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
                  'assets/${exercise.imageName}',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      exercise.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children:
                          exercise.tags.map((tag) => TagChip(tag)).toList(),
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

class TagChip extends StatelessWidget {
  final String tag;

  const TagChip(this.tag, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
  }
}
