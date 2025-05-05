import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sissifit/models/logged_session.dart';

class FirebaseApi {
  Map<String, dynamic> calculateStats(List<LoggedSession> sessions) {
    int totalExercises = 0;
    int totalReps = 0;
    // The number of sessions is simply the list length
    int totalSessions = sessions.length;

    for (var session in sessions) {
      totalExercises += session.workouts.length;
      for (var workout in session.workouts) {
        for (var workoutSet in workout.sets) {
          totalReps += workoutSet.reps;
        }
      }
    }

    return {
      'totalExercises': totalExercises,
      'totalReps': totalReps,
      'totalSessions': totalSessions,
    };
  }

  Future<List<LoggedSession>> fetchRecentSessions(String userId) async {
    try {
      // Define the start date for the query (e.g., 30 days ago)
      final startDate = DateTime.now().subtract(const Duration(days: 30));
      final startTimestamp = Timestamp.fromDate(startDate);

      // Get a reference to the user's logged_sessions subcollection
      final sessionsCollectionRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('logged_sessions');

      // Query documents where the 'date' field is on or after the start date,
      // ordered by date descending (most recent first).
      QuerySnapshot snapshot =
          await sessionsCollectionRef
              .where('date', isGreaterThanOrEqualTo: startTimestamp)
              .orderBy('date', descending: true)
              .get();

      // Map the fetched documents to your LoggedSession model
      List<LoggedSession> sessions =
          snapshot.docs.map((doc) => LoggedSession.fromFirestore(doc)).toList();

      return sessions;
    } catch (e) {
      print("Error fetching recent sessions for user $userId: $e");
      // Handle the error appropriately (e.g., show a message to the user)
      rethrow; // Re-throw or return an empty list depending on desired error handling
    }
  }
}
