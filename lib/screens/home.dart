import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sissifit/models/logged_session.dart'; // Your LoggedSession model
import 'package:sissifit/screens/choose_day.dart'; // Your ChooseDay page
import 'package:sissifit/widgets/stat_show_widget.dart'; // Your StatShowWidget
import 'package:sissifit/widgets/status_graph.dart'; // Your StatusGraph (needs implementation)

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Future to hold the result of fetching sessions and calculating stats
  late Future<Map<String, dynamic>> _statsAndSessionsFuture;

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
        actions: [
          // Logout button
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // The StreamBuilder in main.dart (if still present)
              // or the auth check in Splash Screen will handle navigation.
              // If not, manually navigate to LoginPage:
              // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
            },
          ),
        ],
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            Expanded(
              flex: 5,
              // Use FutureBuilder to wait for stats data
              child: FutureBuilder<Map<String, dynamic>>(
                future: _statsAndSessionsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show loading indicators while data is being fetched
                    return const Row(
                      children: [
                        Expanded(
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        Expanded(
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    // Show an error message if fetching failed
                    return Center(
                      child: Text('Error loading stats: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData) {
                    // Should not happen if connectionState is done, but good check
                    return const Center(
                      child: Text('No stats data available.'),
                    );
                  } else {
                    // Data is loaded, display the stats using the StatShowWidget
                    final stats = snapshot.data!;
                    return Row(
                      children: [
                        Expanded(
                          child: StatShowWidget(
                            internalPadding: 0,
                            horizontalPadding: 12,
                            verticalPadding: 8,
                            label: "Sets",
                            number: stats['totalSets'].toString(),
                            //labelStyle: textTh.headlineMedium!,
                            //numberStyle: textTh.displayMedium!,
                            labelStyle: textTh.titleLarge!,
                            numberStyle: textTh.headlineLarge!,
                            borderRadius: 16,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                child: StatShowWidget(
                                  internalPadding: 0,
                                  horizontalPadding: 12,
                                  verticalPadding: 8,
                                  label: "Longest Streak Days",
                                  number: stats['longestStreak'].toString(),
                                  //labelStyle: textTh.titleLarge!,
                                  //numberStyle: textTh.headlineSmall!,
                                  labelStyle: textTh.titleMedium!,
                                  numberStyle: textTh.headlineSmall!,
                                  borderRadius: 8,
                                ),
                              ),
                              Expanded(
                                child: StatShowWidget(
                                  internalPadding: 0,
                                  horizontalPadding: 12,
                                  verticalPadding: 8,
                                  label: "Reps",
                                  number: stats['totalReps'].toString(),
                                  labelStyle: textTh.titleLarge!,
                                  numberStyle: textTh.headlineSmall!,
                                  borderRadius: 8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Your Performance", // Indicate date range
                    style: textTh.titleLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
            ),
            // Use another FutureBuilder (or the same one) to pass session data to the graph
            Expanded(
              flex: 4, // Adjust flex based on your layout needs
              child: FutureBuilder<Map<String, dynamic>>(
                future: _statsAndSessionsFuture, // Use the same future
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error loading graph data: ${snapshot.error}',
                      ),
                    );
                  } else if (!snapshot.hasData ||
                      (snapshot.data!['recentSessions'] as List).isEmpty) {
                    return const Center(
                      child: Text('No recent session data for graph.'),
                    );
                  } else {
                    // Data is loaded, pass the list of sessions to your StatusGraph widget
                    final recentSessions =
                        snapshot.data!['recentSessions'] as List<LoggedSession>;
                    return StatusGraph(
                      sessionsData: recentSessions,
                    ); // Pass the data
                  }
                },
              ),
            ),
            Expanded(
              flex: 3, // Adjust flex based on your layout needs
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      fixedSize: Size(size.width * 0.8, 60), // Adjust size
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: () {
                      // Navigate to the ChooseDay page to start a new workout
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ChooseDay()),
                      );
                    },
                    child: Text(
                      "Exercise Today",
                      style: textTh.headlineMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
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
    // Start fetching data when the widget is created
    _statsAndSessionsFuture = _fetchStatsAndSessions();
  }

  // Function to fetch recent sessions and calculate stats
  Future<Map<String, dynamic>> _fetchStatsAndSessions() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      // Handle case where user is not logged in (should be caught by splash screen, but safety)
      print("HomePage: User not logged in!");
      // Return default empty stats and sessions
      return {
        'totalExercises': 0,
        'totalReps': 0,
        'totalSessions': 0,
        'recentSessions': <LoggedSession>[],
      };
    }

    try {
      // Define the date range (e.g., last 30 days)
      final fourtyFiveDaysAgo = DateTime.now().subtract(
        const Duration(days: 45),
      );
      final startTimestamp = Timestamp.fromDate(fourtyFiveDaysAgo);

      // Query logged sessions for the current user within the date range
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('logged_sessions')
              .where('date', isGreaterThanOrEqualTo: startTimestamp)
              .orderBy('date', descending: true) // Most recent first
              .get();

      // Map documents to LoggedSession objects
      List<LoggedSession> recentSessions =
          snapshot.docs.map((doc) => LoggedSession.fromFirestore(doc)).toList();

      // Calculate aggregate stats
      int totalExercises = 0;
      int totalReps = 0;
      int totalSets = 0;
      var sessionDatesSet = recentSessions.map((sesh) => sesh.date).toSet();
      var sessionDates = sessionDatesSet.toList();
      sessionDates.sort();
      int longestStreak = 0;
      int currentStreak = 1;
      for (int i = 0; i < sessionDates.length - 1; i++) {
        int diffInDays = sessionDates[i + 1].difference(sessionDates[i]).inDays;
        if (diffInDays == 1) {
          currentStreak++;
        } else if (diffInDays > 1) {
          if (currentStreak > longestStreak) {
            longestStreak = currentStreak;
          }
          currentStreak = 1;
        }
      }
      if (currentStreak > longestStreak) {
        longestStreak = currentStreak;
      }

      for (var session in recentSessions) {
        for (var workout in session.workouts) {
          totalSets += workout.sets.length;
          for (var workoutSet in workout.sets) {
            totalReps += workoutSet.reps;
          }
        }
      }

      // Return a map containing both stats and the list of sessions
      return {
        'totalExercises': totalExercises,
        'longestStreak': longestStreak,
        'totalSets': totalSets,
        'totalReps': totalReps,
        'totalSessions': recentSessions.length,
        'recentSessions': recentSessions, // Pass the list for the graph/history
      };
    } catch (e) {
      print("Error fetching stats and sessions: $e");
      // Show an error message to the user or return default values
      // For simplicity, returning default values on error here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load workout data: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return {
        'totalExercises': 0,
        'totalSets': 0,
        'totalReps': 0,
        'totalSessions': 0,
        'recentSessions': <LoggedSession>[],
      };
    }
  }
}
