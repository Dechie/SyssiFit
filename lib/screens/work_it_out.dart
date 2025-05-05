// import 'package:flutter/material.dart';
// import 'package:sissifit/local_data/exercises.dart';
// import 'package:sissifit/models/exercise.dart';
// import 'package:sissifit/models/workout.dart';
// import 'package:sissifit/models/workout_category.dart';
// import 'package:sissifit/screens/session_page.dart';

// class WorkItOut extends StatefulWidget {
//   final WorkoutCategory category;
//   const WorkItOut({super.key, required this.category});

//   @override
//   State<WorkItOut> createState() => _WorkItOutState();
// }

// class _WorkItOutState extends State<WorkItOut> {
//   List<Exercise> exercises = [];

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.sizeOf(context);
//     var textTh = Theme.of(context).textTheme;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: const Text('SissiFit'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             Expanded(
//               flex: 1,
//               child: Text(
//                 "Choose Your Workout Type:",
//                 style: textTh.titleLarge!.copyWith(fontWeight: FontWeight.w700),
//               ),
//             ),
//             Expanded(
//               flex: 8,
//               child: ListView(
//                 children: [
//                   for (var exc in exercises)
//                     Card(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: ListTile(
//                         title: Text(
//                           exc.name,
//                           style: textTh.bodyLarge!.copyWith(
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         trailing: CircleAvatar(
//                           backgroundColor: Colors.green,
//                           radius: 40,
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//             Expanded(
//               flex: 1,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 onPressed: () {
//                   List<Workout> sessionWorkouts =
//                       exercises
//                           .map((exr) => Workout.fromExercise(exr))
//                           .toList();
//                   Navigator.of(context).push(
//                      MaterialPageRoute(
//                       builder: (__) => SessionPage(workouts: sessionWorkouts),
//                     ),
//                   );
//                 },
//                 child: Text("Go to Workout"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void initState() {
//     exercises =
//         allExercises
//             .where((exc) => widget.category.containsExercise(exc))
//             .toList();
//     super.initState();
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:flutter/material.dart';
import 'package:sissifit/models/exercise.dart'; // Your Exercise model
import 'package:sissifit/models/logged_session.dart'; // Your LoggedSession model
import 'package:sissifit/models/workout.dart'; // Your Workout model
import 'package:sissifit/models/workout_category.dart'; // Your WorkoutCategory model
import 'package:sissifit/screens/session_page.dart'; // Your SessionPage

class WorkItOut extends StatefulWidget {
  final WorkoutCategory category;
  const WorkItOut({super.key, required this.category});

  @override
  State<WorkItOut> createState() => _WorkItOutState();
}

class _WorkItOutState extends State<WorkItOut> {
  // Future to hold the result of fetching and filtering exercises
  late Future<List<Exercise>> _exercisesFuture;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    var textTh = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.category.name,
          style: TextStyle(fontWeight: FontWeight.w600),
        ), // Use category name as title
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                "Exercises for ${widget.category.name}",
                style: textTh.titleLarge!.copyWith(
                  fontWeight: FontWeight.w700,

                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            Expanded(
              flex: 8,
              // Use FutureBuilder to handle the asynchronous fetching and filtering
              child: FutureBuilder<List<Exercise>>(
                future: _exercisesFuture, // The future that fetches and filters
                builder: (context, snapshot) {
                  // Check the state of the future
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show a loading indicator while data is being fetched
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    // Show an error message if an error occurred
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    // Show a message if no exercises were found for this category
                    return const Center(
                      child: Text('No exercises found for this category.'),
                    );
                  } else {
                    // Data has been successfully fetched and filtered
                    final exercises = snapshot.data!;
                    return ListView.builder(
                      itemCount: exercises.length,
                      itemBuilder: (_, index) {
                        final exc = exercises[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            title: Text(
                              exc.name,
                              style: textTh.bodyLarge!.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onPrimaryContainer,
                              ),
                            ),
                            // Add trailing icon/image if you have one
                            trailing: const CircleAvatar(
                              backgroundColor: Colors.green,
                              radius: 40,
                              // backgroundImage: AssetImage(AppFunctions.getImage(exc.name)),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: FutureBuilder<List<Exercise>>(
                // Use a FutureBuilder here too to ensure exercises are loaded before enabling the button
                future: _exercisesFuture,
                builder: (context, snapshot) {
                  // Check if data is loaded and there are exercises
                  bool isDataLoadedAndNotEmpty =
                      snapshot.connectionState == ConnectionState.done &&
                      !snapshot.hasError &&
                      snapshot.hasData &&
                      snapshot.data!.isNotEmpty;

                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    // Enable the button only when data is loaded and not empty
                    onPressed:
                        isDataLoadedAndNotEmpty
                            ? () {
                              // Get the loaded exercises
                              final exercises = snapshot.data!;

                              // Get the current user's ID from Firebase Auth
                              final userId =
                                  FirebaseAuth.instance.currentUser?.uid;
                              if (userId == null) {
                                // This case should ideally not be reached if auth check is done
                                debugPrint("WorkItOut: User not logged in!");
                                // Optionally show a message or navigate to login
                                return;
                              }

                              // Create a list of Workout instances from the selected Exercises
                              List<Workout> sessionWorkouts =
                                  exercises
                                      .map(
                                        (exr) => Workout.fromExercise(exr),
                                      ) // Use your fromExercise factory
                                      .toList();

                              // Create the initial LoggedSession object
                              // The 'id' is a placeholder; Firestore will assign the actual document ID when saved
                              final initialSession = LoggedSession(
                                id: '', // Placeholder ID
                                userId: userId, // Link to the current user
                                date:
                                    DateTime.now(), // Record the current date and time
                                workoutCategoryId:
                                    widget
                                        .category
                                        .id, // Link to the selected category
                                workouts:
                                    sessionWorkouts, // Include the list of workouts
                              );

                              // Navigate to the SessionPage, passing the initial session object
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (__) => SessionPage(
                                        initialSession: initialSession,
                                      ), // Pass the session
                                ),
                              );
                            }
                            : null, // Disable the button if data is not ready
                    child: Text("Go to Workout"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Start fetching all exercises and then filter them based on the category
    _exercisesFuture = _fetchAndFilterExercises();
  }

  // Function to fetch all Exercises from Firestore and filter them by category
  Future<List<Exercise>> _fetchAndFilterExercises() async {
    try {
      // Get a snapshot of the documents in the 'exercises' collection
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('exercises').get();

      // Map each document to an Exercise object using the fromFirestore factory
      List<Exercise> allExercises =
          snapshot.docs.map((doc) => Exercise.fromFirestore(doc)).toList();

      // Filter the fetched exercises based on the selected category's criteria
      List<Exercise> filteredExercises =
          allExercises
              .where((exc) => widget.category.containsExercise(exc))
              .toList();

      return filteredExercises;
    } catch (e) {
      // Print error and show a SnackBar in case of fetching failure
      debugPrint("Error fetching or filtering exercises: $e");
      if (mounted) {
        // Check if the widget is still mounted before showing SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load exercises: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
      // Re-throw the error or return an empty list
      throw e;
    }
  }
}
