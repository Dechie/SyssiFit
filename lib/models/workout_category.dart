import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sissifit/models/exercise.dart';
import 'package:sissifit/utlis/enums.dart';

class WorkoutCategory {
  final String id; // Unique identifier (Firestore document ID)
  final String name; // e.g., "Upper Body Focus", "Leg Day"
  final String
  description; // e.g., "Exercises for chest, shoulders, and triceps."
  // Define criteria by listing relevant types and/or muscle groups
  final List<ExerciseTypeEnum> includedTypes;
  final List<MuscleGroup> includedMuscleGroups;
  // Add any other criteria needed to filter exercises for this category

  WorkoutCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.includedTypes,
    required this.includedMuscleGroups,
  });

  // Factory method to create a WorkoutCategory object from a Firestore DocumentSnapshot.
  // Used when reading WorkoutCategory documents from the '/workout_categories' collection.
  factory WorkoutCategory.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WorkoutCategory(
      id: doc.id, // Get the document ID from the snapshot
      name: data['name'] as String,
      description:
          data['description'] as String? ??
          '', // Handle potential null description
      // Convert list of strings from Firestore back to List<ExerciseTypeEnum> enum values
      includedTypes:
          (data['includedTypes'] as List<dynamic>)
              .map(
                (item) => ExerciseTypeEnum.values.firstWhere(
                  (e) =>
                      e.toString().split('.').last ==
                      item, // Convert enum value to string for comparison
                  orElse:
                      () =>
                          ExerciseTypeEnum
                              .upperBody, // Provide a default or handle error
                ),
              )
              .toList(),
      // Convert list of strings from Firestore back to List<MuscleGroup> enum values
      includedMuscleGroups:
          (data['includedMuscleGroups'] as List<dynamic>)
              .map(
                (item) => MuscleGroup.values.firstWhere(
                  (e) =>
                      e.toString().split('.').last ==
                      item, // Convert enum value to string for comparison
                  orElse:
                      () =>
                          MuscleGroup.lats, // Provide a default or handle error
                ),
              )
              .toList(),
    );
  }

  // Method to check if an Exercise fits this category based on included types and muscle groups.
  bool containsExercise(Exercise exercise) {
    // Check if the exercise's type is included in the category's types
    if (includedTypes.contains(exercise.exerciseType) &&
        exercise.primaryMuscleGroups.any(
          (mg) => includedMuscleGroups.contains(mg),
        )) {
      return true;
    }
    return false;
  }
}
