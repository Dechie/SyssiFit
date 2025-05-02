import 'package:flutter/material.dart';
import 'package:sissifit/local_data/exercises.dart';
import 'package:sissifit/models/exercise.dart';
import 'package:sissifit/models/workout.dart';
import 'package:sissifit/models/workout_category.dart';
import 'package:sissifit/screens/session_page.dart';

class WorkItOut extends StatefulWidget {
  final WorkoutCategory category;
  const WorkItOut({super.key, required this.category});

  @override
  State<WorkItOut> createState() => _WorkItOutState();
}

class _WorkItOutState extends State<WorkItOut> {
  List<Exercise> exercises = [];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    var textTh = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('SissiFit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                "Choose Your Workout Type:",
                style: textTh.titleLarge!.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            Expanded(
              flex: 8,
              child: ListView(
                children: [
                  for (var exc in exercises)
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        title: Text(
                          exc.name,
                          style: textTh.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: CircleAvatar(
                          backgroundColor: Colors.green,
                          radius: 40,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  List<Workout> sessionWorkouts =
                      exercises
                          .map((exr) => Workout.fromExercise(exr))
                          .toList();
                  Navigator.of(context).push(
                     MaterialPageRoute(
                      builder: (__) => SessionPage(workouts: sessionWorkouts),
                    ),
                  );
                },
                child: Text("Go to Workout"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    exercises =
        allExercises
            .where((exc) => widget.category.containsExercise(exc))
            .toList();
    super.initState();
  }
}
