import 'package:flutter/material.dart';
import 'package:sissifit/models/logged_session.dart'; // Your LoggedSession model

class StatusGraph extends StatelessWidget {
  final List<LoggedSession> sessionsData;
  const StatusGraph({super.key, required this.sessionsData});

  @override
  Widget build(BuildContext context) {
    // Aggregate sets by day
    final dailySets = _aggregateSetsByDay(sessionsData);

    // Determine the date range for the graph (e.g., last 30 days)
    // You might want to make this configurable or match the fetch range
    const int numberOfDays = 60;
    final today = DateTime.now();
    final startDate = DateTime(
      today.year,
      today.month,
      today.day,
    ).subtract(Duration(days: numberOfDays - 1));

    // Create a list of dates from startDate to today
    List<DateTime> dates = List.generate(numberOfDays, (index) {
      return startDate.add(Duration(days: index));
    });

    // Days of the week labels (adjust if your week starts on a different day)
    List<String> daysOfWeekLabels = [
      "Mon",
      "Tue",
      "Wed",
      "Thu",
      "Fri",
      "Sat",
      "Sun",
    ];

    // Calculate the starting day of the week for the grid alignment
    // The first day of the 'dates' list determines the offset
    final int startDayOfWeek =
        dates.first.weekday - 1; // Monday is 1, so subtract 1 for 0-index

    return SizedBox(
      height:
          MediaQuery.of(context).size.height * 0.3, // Use MediaQuery for height
      width: MediaQuery.of(context).size.width, // Use MediaQuery for width
      child: Row(
        children: [
          // Column for Day of the Week Labels
          Padding(
            padding: const EdgeInsets.only(left: 8.0), // Add some left padding
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.spaceAround, // Distribute space
              children: List.generate(7, (index) {
                // Calculate the day index relative to the first day of the week displayed
                // If the first day is Wednesday (index 2), the labels should start from Wed
                final labelIndex = (startDayOfWeek + index) % 7;
                return Expanded(
                  // Use Expanded to make labels take equal vertical space
                  child: Align(
                    alignment:
                        Alignment.centerRight, // Align labels to the right
                    child: Text(
                      daysOfWeekLabels[labelIndex],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ), // Adjust style
                    ),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8), // Adjust padding
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7, // 7 days in a column
                crossAxisSpacing: 4, // Spacing between columns (days)
                mainAxisSpacing: 4, // Spacing between rows (weeks)
              ),
              scrollDirection: Axis.horizontal, // Scroll horizontally
              itemCount:
                  numberOfDays +
                  startDayOfWeek, // Total cells needed (days + offset)
              itemBuilder: (_, index) {
                // Calculate the date for the current cell
                // Cells before the start day of the week are empty placeholders
                if (index < startDayOfWeek) {
                  return Container(); // Empty container for offset
                }

                final dateIndex = index - startDayOfWeek;
                final currentDate = dates[dateIndex];
                final dateKey = currentDate.toIso8601String().substring(0, 10);
                final setsToday =
                    dailySets[dateKey] ??
                    0; // Get sets for this date (default to 0)

                // Determine the color based on the number of sets
                final cellColor = _getColorForSets(setsToday);

                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 0.5, // Thinner border
                      color: Colors.black12, // Lighter border color
                    ),
                    borderRadius: BorderRadius.circular(
                      2,
                    ), // Smaller border radius
                    color: cellColor, // Set the color based on sets
                  ),
                  // Optionally add a tooltip to show date and sets on hover/long press
                  child: Tooltip(
                    message: "${dateKey}: ${setsToday} Sets",
                    child:
                        Container(), // Empty container for the grid cell visual
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Function to aggregate total sets per day from sessions data
  Map<String, int> _aggregateSetsByDay(List<LoggedSession> sessions) {
    Map<String, int> dailySets = {};

    for (var session in sessions) {
      // Get the date part of the session date
      final dateKey = DateTime(
        session.date.year,
        session.date.month,
        session.date.day,
      ).toIso8601String().substring(0, 10);

      int sessionTotalSets = 0;
      for (var workout in session.workouts) {
        sessionTotalSets +=
            workout.sets.length; // Count the number of sets in the workout
        // Or sum reps if you want intensity by total reps:
        // for (var set in workout.sets) {
        //   sessionTotalSets += set.reps;
        // }
      }

      // Add to the total for this day. Use += to handle multiple sessions on the same day.
      dailySets[dateKey] = (dailySets[dateKey] ?? 0) + sessionTotalSets;
    }
    return dailySets;
  }

  // Function to get the color based on the number of sets
  Color _getColorForSets(int sets) {
    if (sets == 0) {
      return Colors.grey[400]!; // Lightest color for no activity
    } else if (sets < 5) {
      return Colors.green[100]!; // Low activity
    } else if (sets < 10) {
      return Colors.green[300]!; // Medium activity
    } else if (sets < 20) {
      return Colors.green[500]!; // High activity
    } else {
      return Colors.green[700]!; // Very high activity
    }
  }
}
