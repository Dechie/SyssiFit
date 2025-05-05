// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:sissifit/models/logged_session.dart';
// import 'package:sissifit/models/workout.dart';
// import 'package:sissifit/models/workout_set.dart';

// class SessionPage extends StatefulWidget {
//   final List<Workout> workouts;

//   const SessionPage({super.key, required this.workouts});

//   @override
//   State<SessionPage> createState() => _SessionPageState();
// }

// class _SessionPageState extends State<SessionPage> {
//   late final PageController pageCtrl;
//   double rep = 0;
//   List<Workout> workouts = [];
//   @override
//   Widget build(BuildContext context) {
//     final textTh = Theme.of(context).textTheme;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: const Text('SissiFit'),
//       ),
//       body: Column(
//         children: [
//           Align(alignment: Alignment.centerRight),
//           Expanded(
//             flex: 17,
//             child: PageView.builder(
//               controller: pageCtrl,
//               itemCount: workouts.length,
//               itemBuilder: (context, index) {
//                 var currentWorkout = widget.workouts[index];
//                 return Card(
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(26),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       Text(
//                         currentWorkout.title,
//                         style: textTh.headlineMedium!.copyWith(
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       CircleAvatar(
//                         radius: 120,
//                         // backgroundImage: AssetImage(
//                         //   AppFunctions.getImage(currentWorkout.title),
//                         // ),
//                         backgroundColor: Colors.green,
//                       ),
//                       Text(
//                         "Set ${workouts[index].sets.length + 1}",
//                         style: textTh.titleMedium!.copyWith(
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       FilledButton(
//                         style: FilledButton.styleFrom(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           backgroundColor: Colors.green,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             rep = 0;
//                             workouts[index].sets.add(WorkoutSet(reps: 0));
//                           });
//                         },
//                         child: Text(
//                           "Add Set",
//                           style: textTh.bodyMedium!.copyWith(
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),

//                       Padding(
//                         padding: const EdgeInsets.only(left: 12.0, right: 12.0),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: Slider(
//                                 label: "${rep.toInt()}",
//                                 min: 0,
//                                 max: 30,
//                                 value: rep,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     rep = value.round().toDouble();
//                                   });
//                                   workouts[index].sets.last.reps = rep.toInt();
//                                 },
//                               ),
//                             ),
//                             Text(
//                               "${workouts[index].sets.last.reps} Reps",
//                               style: textTh.bodyLarge!.copyWith(
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       FilledButton(
//                         style: FilledButton.styleFrom(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           backgroundColor: Colors.green,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             rep = 0;
//                           });
//                           pageCtrl.nextPage(
//                             duration: Duration(milliseconds: 500),
//                             curve: Curves.decelerate,
//                           );
//                         },
//                         child: Text(
//                           "Next Exercise",
//                           style: textTh.bodyMedium!.copyWith(
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//           Expanded(
//             flex: 2,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 10.0),
//               child: FilledButton(
//                 style: FilledButton.styleFrom(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   backgroundColor: Colors.green,
//                 ),
//                 onPressed: () async {
//                   for (var ex in workouts) {
//                     debugPrint(
//                       "Workout(tite: ${ex.title}, sets: [ ${ex.sets.map((e) => "${e.reps},")} ])",
//                     );
//                   }

//                   await _saveSession();
//                 },
//                 child: Text(
//                   "Confirm Exercise",
//                   style: textTh.bodyLarge!.copyWith(
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // In your Confirm Exercise button's onPressed:

//   @override
//   void initState() {
//     pageCtrl = PageController();
//     workouts = widget.workouts;
//     super.initState();
//   }

//   // In your SessionPage state class

//   Future<void> _saveSession() async {
//     // Get the current user's ID (requires Firebase Auth setup)
//     final userId = FirebaseAuth.instance.currentUser?.uid;
//     if (userId == null) {
//       // Handle the case where the user is not logged in
//       print("User not logged in!");
//       return;
//     }

//     // Ensure the currentSession object is fully populated with workouts and sets
//     // (This part depends on how you manage the currentSession object)
//     // Assuming 'workouts' list is the state variable
//     LoggedSession session = LoggedSession(
//       id: "",
//       userId: userId,
//       date: DateTime.now(),
//       workouts: workouts,
//     );

//     try {
//       // Get a reference to the logged_sessions subcollection for the current user
//       final sessionsCollectionRef = FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .collection('logged_sessions');

//       // Add the LoggedSession object to Firestore
//       // You'll need toJson() method on your LoggedSession model
//       await sessionsCollectionRef.add(session.toJson());

//       debugPrint("Session saved successfully!");
//       // Navigate back or show a success message
//       if (mounted) {
//         Navigator.pop(context);
//       }
//     } catch (e) {
//       debugPrint("Error saving session: $e");
//       // Show an error message to the user
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:flutter/material.dart';
import 'package:sissifit/models/logged_session.dart'; // Your LoggedSession model
import 'package:sissifit/models/workout_set.dart'; // Your Set model (renamed from WorkoutSet)

class SessionPage extends StatefulWidget {
  // Accept the initial LoggedSession object instead of just a list of Workouts
  final LoggedSession initialSession;

  const SessionPage({super.key, required this.initialSession});

  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  late final PageController pageCtrl;
  double rep = 0;
  // Manage the session data in the state using the LoggedSession object
  late LoggedSession currentSession;

  @override
  Widget build(BuildContext context) {
    final textTh = Theme.of(context).textTheme;
    // Check if there are workouts in the session
    final bool hasWorkouts = currentSession.workouts.isNotEmpty;
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          'FitTrack',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body:
          !hasWorkouts // Show a message if no workouts are in the session
              ? Center(
                child: Text(
                  'No exercises selected for this session.',
                  style: textTh.bodyLarge!.copyWith(
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              )
              : Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                  ), // Keep this if needed for layout
                  Expanded(
                    flex: 17,
                    child: PageView.builder(
                      controller: pageCtrl,
                      itemCount:
                          currentSession
                              .workouts
                              .length, // Use currentSession.workouts
                      itemBuilder: (context, index) {
                        var currentWorkout =
                            currentSession
                                .workouts[index]; // Get the current workout from the session
                        // Ensure there's at least one set to show the slider for the last set
                        final bool hasSets = currentWorkout.sets.isNotEmpty;

                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ), // Add margin
                          child: Padding(
                            // Add padding inside the card
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              spacing: 12,
                              children: [
                                Text(
                                  currentWorkout
                                      .title, // Use the title from the Workout model
                                  textAlign:
                                      TextAlign.center, // Center the title
                                  style: textTh.headlineMedium!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.onPrimaryContainer,
                                  ),
                                ),
                                // Placeholder for image/icon
                                const CircleAvatar(
                                  radius: 100, // Adjust radius
                                  backgroundColor: Colors.green,
                                  // backgroundImage: AssetImage(AppFunctions.getImage(currentWorkout.title)),
                                  child: Icon(
                                    Icons.fitness_center,
                                    size: 80,
                                    color: Colors.white,
                                  ), // Placeholder icon
                                ),
                                Text(
                                  // Display the number of sets already added + 1 for the next set
                                  "Set ${currentWorkout.sets.length + 1}",
                                  style: textTh.titleMedium!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.onPrimaryContainer,
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
                                      // Add a new Set object to the current workout's sets list
                                      currentWorkout.sets.add(
                                        WorkoutSet(reps: rep.toInt()),
                                      ); // Save current slider value as reps
                                      rep = 0; // Reset slider for the next set
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
                                  padding: const EdgeInsets.only(
                                    left: 12.0,
                                    right: 12.0,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Slider(
                                          label: "${rep.toInt()}",
                                          min: 0,
                                          max: 30, // Adjust max reps as needed
                                          value: rep,
                                          onChanged: (value) {
                                            setState(() {
                                              rep = value.round().toDouble();
                                              // Update the slider value, but reps are saved when "Add Set" is pressed
                                            });
                                          },
                                        ),
                                      ),
                                      Text(
                                        "${rep.toInt()} Reps", // Display the current slider value
                                        style: textTh.bodyLarge!.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: colorScheme.onPrimaryContainer,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Display previously added sets
                                if (hasSets) // Only show if there are sets
                                  Expanded(
                                    // Use Expanded to give the list space
                                    child: ListView.builder(
                                      shrinkWrap:
                                          true, // Use shrinkWrap for ListView inside Column
                                      itemCount: currentWorkout.sets.length,
                                      itemBuilder: (context, setIndex) {
                                        final set =
                                            currentWorkout.sets[setIndex];
                                        return Text(
                                          "Set ${setIndex + 1}: ${set.reps} Reps",
                                          style: textTh.bodyMedium!.copyWith(
                                            color:
                                                colorScheme.onPrimaryContainer,
                                          ),
                                        );
                                      },
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
                                    // Optionally add the current set before moving to the next page
                                    // if you want to ensure the last set is saved even if "Add Set" wasn't pressed
                                    if (rep > 0) {
                                      // Only add if reps > 0
                                      setState(() {
                                        currentWorkout.sets.add(
                                          WorkoutSet(reps: rep.toInt()),
                                        );
                                        rep = 0; // Reset slider
                                      });
                                    }

                                    // Move to the next exercise in the PageView
                                    pageCtrl.nextPage(
                                      duration: const Duration(
                                        milliseconds: 500,
                                      ),
                                      curve: Curves.decelerate,
                                    );
                                  },
                                  child: Text(
                                    // Change button text for the last page
                                    index == currentSession.workouts.length - 1
                                        ? "Finish Session"
                                        : "Next Exercise",
                                    style: textTh.bodyMedium!.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
                          backgroundColor:
                              Colors.green, // Green for confirm/save
                        ),
                        // Only enable if there's at least one workout and potentially some data logged
                        onPressed:
                            hasWorkouts
                                ? () async {
                                  // Optionally add the current set before saving
                                  final currentIndex = pageCtrl.page!.round();
                                  if (rep > 0) {
                                    setState(() {
                                      currentSession.workouts[currentIndex].sets
                                          .add(WorkoutSet(reps: rep.toInt()));
                                      rep = 0;
                                    });
                                  }
                                  await _saveSession(); // Call the save function
                                }
                                : null, // Disable button if no workouts
                        child: Text(
                          "Confirm & Save Session", // Clearer button text
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

  @override
  void dispose() {
    pageCtrl.dispose(); // Dispose the PageController to prevent memory leaks
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    pageCtrl = PageController();
    // Initialize the state's session data with the passed initial session
    currentSession = widget.initialSession;
    // Initialize the slider value based on the first workout's first set if available
    if (currentSession.workouts.isNotEmpty &&
        currentSession.workouts.first.sets.isNotEmpty) {
      rep = currentSession.workouts.first.sets.last.reps.toDouble();
    }
    // Add a listener to the PageController to update the slider when the page changes
    pageCtrl.addListener(() {
      // Ensure the page is a valid integer index
      if (pageCtrl.page != null &&
          pageCtrl.page == pageCtrl.page!.roundToDouble()) {
        final currentIndex = pageCtrl.page!.round();
        // Reset rep slider when moving to a new exercise
        setState(() {
          rep = 0;
          // Optionally, load the last set's reps if the workout already has sets
          if (currentSession.workouts[currentIndex].sets.isNotEmpty) {
            rep =
                currentSession.workouts[currentIndex].sets.last.reps.toDouble();
          }
        });
      }
    });
  }

  // Function to save the completed session data to Firebase
  Future<void> _saveSession() async {
    // Get the current user's ID from Firebase Auth
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      // Handle the case where the user is not logged in (shouldn't happen with auth check)
      debugPrint("SessionPage: User not logged in!");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: User not logged in.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
      return;
    }

    try {
      // Get a reference to the logged_sessions subcollection for the current user
      final sessionsCollectionRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('logged_sessions');

      // Add the LoggedSession object to Firestore.
      // Firebase will automatically generate a unique document ID.
      // The toJson() method converts the LoggedSession object and its nested
      // Workouts and Sets into a Map suitable for Firestore.
      await sessionsCollectionRef.add(currentSession.toJson());

      debugPrint("Session saved successfully!");
      // Show a success message and navigate back to the home page
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Workout session saved!'),
            backgroundColor: Colors.green,
          ),
        );
        // Navigate back to the root (HomePage) or the previous page
        Navigator.popUntil(
          context,
          (route) => route.isFirst,
        ); // Example: go back to the first route (usually home)
        // Navigator.pop(context); // Example: go back to the previous page (WorkItOut)
      }
    } catch (e) {
      // Handle errors during saving
      debugPrint("Error saving session: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save session: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }
}
