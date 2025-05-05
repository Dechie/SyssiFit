// import 'package:flutter/material.dart';
// import 'package:sissifit/local_data/categories.dart';
// import 'package:sissifit/screens/work_it_out.dart';
// import 'package:sissifit/widgets/workout_category_show.dart';

// class ChooseDay extends StatefulWidget {
//   const ChooseDay({super.key});

//   @override
//   State<ChooseDay> createState() => _ChooseDayState();
// }

// class _ChooseDayState extends State<ChooseDay> {
//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.sizeOf(context);
//     var textTh = Theme.of(context).textTheme;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: const Text('SissiFit'),
//       ),
//       body: SizedBox(
//         height: size.height,
//         width: size.width,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               flex: 1,
//               child: Padding(
//                 padding: const EdgeInsets.all(18.0),
//                 child: Text(
//                   "Choose Your Workout Type:",
//                   style: textTh.titleLarge!.copyWith(
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//               ),
//             ),
//             Expanded(
//               flex: 8,
//               child: GridView.builder(
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   mainAxisSpacing: 20,
//                 ),
//                 itemCount: workoutCategories.length,
//                 itemBuilder:
//                     (_, index) => GestureDetector(
//                       onTap: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder:
//                                 (_) => WorkItOut(
//                                   category: workoutCategories[index],
//                                 ),
//                           ),
//                         );
//                       },
//                       child: WorkoutCategoryShow(
//                         title: workoutCategories[index].name,
//                         description: workoutCategories[index].description,
//                       ),
//                     ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:flutter/material.dart';
import 'package:sissifit/models/workout_category.dart'; // Your WorkoutCategory model
import 'package:sissifit/screens/work_it_out.dart'; // Your WorkItOut page
import 'package:sissifit/widgets/workout_category_show.dart'; // Your WorkoutCategoryShow widget

class ChooseDay extends StatefulWidget {
  const ChooseDay({super.key});

  @override
  State<ChooseDay> createState() => _ChooseDayState();
}

class _ChooseDayState extends State<ChooseDay> {
  // Future to hold the result of fetching categories from Firebase
  late Future<List<WorkoutCategory>> _categoriesFuture;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    var textTh = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          'FitTrack',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  "Choose Your Workout Type:",
                  style: textTh.titleLarge!.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 8,
              // Use FutureBuilder to handle the asynchronous fetching of categories
              child: FutureBuilder<List<WorkoutCategory>>(
                future: _categoriesFuture, // The future that fetches data
                builder: (context, snapshot) {
                  // Check the state of the future
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show a loading indicator while data is being fetched
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    // Show an error message if an error occurred during fetching
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    // Show a message if no categories were found in Firestore
                    return const Center(
                      child: Text('No workout categories found.'),
                    );
                  } else {
                    // Data has been successfully fetched
                    final workoutCategories = snapshot.data!;
                    return GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                          ),
                      itemCount: workoutCategories.length,
                      itemBuilder: (_, index) {
                        final category = workoutCategories[index];
                        return GestureDetector(
                          onTap: () {
                            // Navigate to the WorkItOut page, passing the selected category
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => WorkItOut(category: category),
                              ),
                            );
                          },
                          child: WorkoutCategoryShow(
                            title: category.name,
                            description: category.description,
                          ),
                        );
                      },
                    );
                  }
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
    // Start fetching workout categories from Firebase when the widget initializes
    _categoriesFuture = _fetchWorkoutCategories();
  }

  // Function to fetch Workout Categories from the 'workout_categories' collection in Firestore
  Future<List<WorkoutCategory>> _fetchWorkoutCategories() async {
    try {
      // Get a snapshot of the documents in the 'workout_categories' collection
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance
              .collection('workout_categories')
              .get();

      // Map each document to a WorkoutCategory object using the fromFirestore factory
      List<WorkoutCategory> categories =
          snapshot.docs
              .map((doc) => WorkoutCategory.fromFirestore(doc))
              .toList();

      return categories;
    } catch (e) {
      // Print error and show a SnackBar in case of fetching failure
      debugPrint("Error fetching workout categories: $e");
      if (mounted) {
        // Check if the widget is still mounted before showing SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load workout categories: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
      // Re-throw the error or return an empty list depending on desired error handling
      throw e;
    }
  }
}
