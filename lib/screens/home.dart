import 'package:flutter/material.dart';
import 'package:sissifit/screens/choose_day.dart';
import 'package:sissifit/widgets/stat_show_widget.dart';
import 'package:sissifit/widgets/status_graph.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    var textTh = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('SissiFit'),
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Row(
                children: [
                  Expanded(
                    child: StatShowWidget(
                      internalPadding: 0,
                      horizontalPadding: 12,
                      verticalPadding: 8,
                      label: "Exercises",
                      number: "36",
                      labelStyle: textTh.headlineMedium!,
                      numberStyle: textTh.displayMedium!,
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
                            label: "Reps",
                            number: "128",
                            labelStyle: textTh.headlineSmall!,
                            numberStyle: textTh.headlineMedium!,
                            borderRadius: 8,
                          ),
                        ),
                        Expanded(
                          child: StatShowWidget(
                            internalPadding: 0,
                            horizontalPadding: 12,
                            verticalPadding: 8,
                            label: "workouts",
                            number: "20%",
                            labelStyle: textTh.headlineSmall!,
                            numberStyle: textTh.headlineMedium!,
                            borderRadius: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Your Performance",
                    style: textTh.headlineMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            StatusGraph(sessionsData: []),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      fixedSize: Size(size.width, 60),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).push(MaterialPageRoute(builder: (_) => ChooseDay()));
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
}
