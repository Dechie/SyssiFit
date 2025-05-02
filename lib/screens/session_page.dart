import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sissifit/models/logged_session.dart';
import 'package:sissifit/models/workout.dart';
import 'package:sissifit/models/workout_set.dart';

class SessionPage extends StatefulWidget {
  final List<Workout> workouts;

  const SessionPage({super.key, required this.workouts});

  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  late final PageController pageCtrl;
  double rep = 0;
  List<Workout> workouts = [];
  @override
  Widget build(BuildContext context) {
    final textTh = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('SissiFit'),
      ),
      body: Column(
        children: [
          Align(alignment: Alignment.centerRight),
          Expanded(
            flex: 17,
            child: PageView.builder(
              controller: pageCtrl,
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                var currentWorkout = widget.workouts[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        currentWorkout.title,
                        style: textTh.headlineMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      CircleAvatar(
                        radius: 120,
                        // backgroundImage: AssetImage(
                        //   AppFunctions.getImage(currentWorkout.title),
                        // ),
                        backgroundColor: Colors.green,
                      ),
                      Text(
                        "Set ${workouts[index].sets.length + 1}",
                        style: textTh.titleMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          setState(() {
                            rep = 0;
                            workouts[index].sets.add(WorkoutSet(reps: 0));
                          });
                        },
                        child: Text(
                          "Add Set",
                          style: textTh.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Slider(
                                label: "${rep.toInt()}",
                                min: 0,
                                max: 30,
                                value: rep,
                                onChanged: (value) {
                                  setState(() {
                                    rep = value.round().toDouble();
                                  });
                                  workouts[index].sets.last.reps = rep.toInt();
                                },
                              ),
                            ),
                            Text(
                              "${workouts[index].sets.last.reps} Reps",
                              style: textTh.bodyLarge!.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          setState(() {
                            rep = 0;
                          });
                          pageCtrl.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.decelerate,
                          );
                        },
                        child: Text(
                          "Next Exercise",
                          style: textTh.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: FilledButton(
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.green,
                ),
                onPressed: () async {
                  for (var ex in workouts) {
                    debugPrint(
                      "Workout(tite: ${ex.title}, sets: [ ${ex.sets.map((e) => "${e.reps},")} ])",
                    );
                  }

                  await _saveSession();
                },
                child: Text(
                  "Confirm Exercise",
                  style: textTh.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // In your Confirm Exercise button's onPressed:

  @override
  void initState() {
    pageCtrl = PageController();
    workouts = widget.workouts;
    super.initState();
  }

  // In your SessionPage state class

  Future<void> _saveSession() async {
    // Get the current user's ID (requires Firebase Auth setup)
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      // Handle the case where the user is not logged in
      print("User not logged in!");
      return;
    }

    // Ensure the currentSession object is fully populated with workouts and sets
    // (This part depends on how you manage the currentSession object)
    // Assuming 'workouts' list is the state variable
    LoggedSession session = LoggedSession(
      id: "",
      userId: userId,
      date: DateTime.now(),
      workouts: workouts,
    );

    try {
      // Get a reference to the logged_sessions subcollection for the current user
      final sessionsCollectionRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('logged_sessions');

      // Add the LoggedSession object to Firestore
      // You'll need toJson() method on your LoggedSession model
      await sessionsCollectionRef.add(session.toJson());


      debugPrint("Session saved successfully!");
      // Navigate back or show a success message
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint("Error saving session: $e");
      // Show an error message to the user
    }
  }
}
