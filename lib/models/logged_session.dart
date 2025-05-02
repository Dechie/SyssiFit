import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sissifit/models/workout.dart';

// class LoggedSession {
//   final String id; // Unique identifier (Firebase document ID)
//   final String userId;
//   final DateTime date;
//   // Optional: Store which category template was used
//   final String? workoutCategoryId;
//   final List<Workout> workouts; // The specific workouts done in this session

//   LoggedSession({
//     required this.id,
//     required this.userId,
//     required this.date,
//     this.workoutCategoryId,
//     required this.workouts,
//   });

//   Map<String, dynamic> toJson() {}
// }

class LoggedSession {
  final String id; // Unique identifier (Firebase document ID)
  final String userId; // Link to the user who performed the session
  final DateTime date; // The specific date and time the session occurred
  final String? workoutCategoryId; // Optional: Reference to the category template used
  List<Workout> workouts; // The specific workouts done in this session

  LoggedSession({
    required this.id,
    required this.userId,
    required this.date,
    this.workoutCategoryId,
    required this.workouts,
  });

  // Method to convert LoggedSession object to a Map for Firestore
  Map<String, dynamic> toJson() {
    return {
      // 'id': id, // Firestore handles the document ID
      'userId': userId,
      'date': Timestamp.fromDate(date), // Convert DateTime to Firestore Timestamp
      'workoutCategoryId': workoutCategoryId,
      'workouts': workouts.map((workout) => workout.toJson()).toList(), // Convert list of Workouts to list of Maps
    };
  }

  // Factory method to create a LoggedSession object from a Firestore DocumentSnapshot
  factory LoggedSession.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LoggedSession(
      id: doc.id, // Get the document ID from the snapshot
      userId: data['userId'] as String,
      date: (data['date'] as Timestamp).toDate(), // Convert Firestore Timestamp to DateTime
      workoutCategoryId: data['workoutCategoryId'] as String?,
      workouts: (data['workouts'] as List<dynamic>)
          .map((workoutJson) => Workout.fromJson(workoutJson as Map<String, dynamic>))
          .toList(),
    );
  }
}
