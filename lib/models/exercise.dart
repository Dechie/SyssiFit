import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sissifit/utlis/enums.dart';

class Exercise {
  final String id; // Unique identifier (Firestore document ID)
  final String name;
  final String description; // Optional
  final List<MuscleGroup> primaryMuscleGroups;
  // Removed secondaryMuscleGroups as per your provided class
  final ExerciseTypeEnum exerciseType; // Use the enum directly

  Exercise({
    
    required this.id,
    required this.name,
    this.description = '',
    required this.primaryMuscleGroups,
    required this.exerciseType,
  });

  // Factory method to create an Exercise object from a Firestore DocumentSnapshot.
  // Used when reading Exercise documents from the '/exercises' collection.
  factory Exercise.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Exercise(
      id: doc.id, // Get the document ID from the snapshot
      name: data['name'] as String,
      description: data['description'] as String? ?? '', // Handle potential null description
      // Convert list of strings from Firestore back to List<MuscleGroup> enum values
      primaryMuscleGroups: (data['primaryMuscleGroups'] as List<dynamic>)
          .map((item) => MuscleGroup.values.firstWhere(
              (e) => e.toString().split('.').last == item, // Convert enum value to string for comparison
              orElse: () => MuscleGroup.lats // Provide a default or handle error if enum not found
          ))
          .toList(),
      // Convert string from Firestore back to ExerciseTypeEnum value
      exerciseType: ExerciseTypeEnum.values.firstWhere(
          (e) => e.toString().split('.').last == data['exerciseType'], // Convert enum value to string for comparison
          orElse: () => ExerciseTypeEnum.upperBody // Provide a default or handle error
      ),
    );
  }
}