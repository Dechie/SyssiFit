import 'package:sissifit/utlis/enums.dart';

class Exercise {
  final String id; // Unique identifier (Firebase document ID)
  final String name;
  final String description; // Optional
  final List<MuscleGroup> primaryMuscleGroups;
  //final List<MuscleGroup> secondaryMuscleGroups; // Optional
  final ExerciseTypeEnum exerciseType; // Use the enum directly

  Exercise({
    required this.id,
    required this.name,
    this.description = '',
    required this.primaryMuscleGroups,
    //this.secondaryMuscleGroups = const [],
    required this.exerciseType,
  });
}
