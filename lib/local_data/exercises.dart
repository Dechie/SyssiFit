import 'package:sissifit/models/exercise.dart';
import 'package:sissifit/utlis/enums.dart';

part 'chest_exercises.dart';
part 'biceps_exercises.dart';
part 'shoulder_exercises.dart';
part 'leg_exercises.dart';

List<Exercise> allExercises = [
  // bicep/back
  dumbBellCurls,
  seatedCableRows,
  latPullDowns,
  // tricep/chest
  dips,
  inclineBenchPress,
  skullCrushers,
  tricepsPulldown,
  // leg
  lunges,
  squats,
  // shoulders/trap
  facePulls,
  lateralRaises,
  shrugs,
  uprightRows,
];
