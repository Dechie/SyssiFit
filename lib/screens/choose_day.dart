import 'package:flutter/material.dart';
import 'package:sissifit/local_data/categories.dart';
import 'package:sissifit/screens/work_it_out.dart';
import 'package:sissifit/widgets/workout_category_show.dart';

class ChooseDay extends StatefulWidget {
  const ChooseDay({super.key});

  @override
  State<ChooseDay> createState() => _ChooseDayState();
}

class _ChooseDayState extends State<ChooseDay> {
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
        height: size.height,
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  "Choose Your Workout Type:",
                  style: textTh.titleLarge!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                ),
                itemCount: workoutCategories.length,
                itemBuilder:
                    (_, index) => GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (_) => WorkItOut(
                                  category: workoutCategories[index],
                                ),
                          ),
                        );
                      },
                      child: WorkoutCategoryShow(
                        title: workoutCategories[index].name,
                        description: workoutCategories[index].description,
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
