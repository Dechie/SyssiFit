import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sissifit/models/workout.dart';

class LoggedSession {
  final String id; // Unique identifier (Firebase document ID)
  final String userId; // Link to the user who performed the session
  final DateTime date; // The specific date and time the session occurred
  final String?
  workoutCategoryId; // Optional: Reference to the category template used (by its Firestore ID)
  List<Workout> workouts; // The specific workouts done in this session

  LoggedSession({
    required this.id,
    required this.userId,
    required this.date,
    this.workoutCategoryId,
    required this.workouts,
  });

  // Factory method to create a LoggedSession object from a Firestore DocumentSnapshot.
  // Used when reading LoggedSession documents.
  factory LoggedSession.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LoggedSession(
      id: doc.id, // Get the document ID from the snapshot
      userId: data['userId'] as String,
      date:
          (data['date'] as Timestamp)
              .toDate(), // Convert Firestore Timestamp to DateTime
      workoutCategoryId: data['workoutCategoryId'] as String?,
      // Convert the list of workout Maps back to a list of Workout objects
      workouts:
          (data['workouts'] as List<dynamic>)
              .map(
                (workoutJson) =>
                    Workout.fromJson(workoutJson as Map<String, dynamic>),
              )
              .toList(),
    );
  }

  // Method to convert LoggedSession object to a Map for Firestore.
  // Used when saving a LoggedSession document.
  Map<String, dynamic> toJson() {
    return {
      // 'id': id, // Firestore handles the document ID, no need to store it as a field
      'userId': userId,
      'date': Timestamp.fromDate(
        date,
      ), // Convert DateTime to Firestore Timestamp
      'workoutCategoryId': workoutCategoryId,
      'workouts':
          workouts
              .map((workout) => workout.toJson())
              .toList(), // Convert list of Workouts to list of Maps
    };
  }
}
