import 'package:sissifit/models/exercise.dart';
import 'package:sissifit/utlis/enums.dart';

class WorkoutCategory {
  final String id; // Unique identifier (Firebase document ID)
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

  // Method to check if an Exercise fits this category
  bool containsExercise(Exercise exercise) {
    // Logic: Does the exercise's type match any included type OR
    // do the exercise's muscle groups intersect with any included muscle group?
    if (includedTypes.contains(exercise.exerciseType) &&
        exercise.primaryMuscleGroups.every(
          (mg) => includedMuscleGroups.contains(mg),
        )) {
      return true;
    }
    //if (exercise.primaryMuscleGroups.any((mg) => includedMuscleGroups.contains(mg))) return true;
    //if (exercise.secondaryMuscleGroups.any((mg) => includedMuscleGroups.contains(mg))) return true;
    return false;
  }
}
