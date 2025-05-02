import 'package:sissifit/models/workout_category.dart';
import 'package:sissifit/utlis/enums.dart';

WorkoutCategory legDay = WorkoutCategory(
  id: "",
  name: "Leg Day",
  description: "Exercises targeting legs",
  includedTypes: [ExerciseTypeEnum.lowerBody],
  includedMuscleGroups: [
    MuscleGroup.glutes,
    MuscleGroup.hamstrings,
    MuscleGroup.quads,
  ],
);

WorkoutCategory pullDay = WorkoutCategory(
  id: "",
  name: "Pull Day",
  description: "Exercises targeting back, biceps and lats.",
  includedTypes: [ExerciseTypeEnum.upperBody],
  includedMuscleGroups: [MuscleGroup.lats, MuscleGroup.biceps],
);
WorkoutCategory pushDay = WorkoutCategory(
  id: "",
  name: "Push Day",
  description: "Exercises targeting chest, shoulders, and triceps",
  includedTypes: [ExerciseTypeEnum.upperBody],
  includedMuscleGroups: [
    MuscleGroup.chest,
    MuscleGroup.triceps,
    MuscleGroup.shoulders,
  ],
);
WorkoutCategory shoulderDay = WorkoutCategory(
  id: "",
  name: "Shoulder Day",
  description: "Exercises targeting delts and traps",
  includedTypes: [ExerciseTypeEnum.upperBody],
  includedMuscleGroups: [MuscleGroup.traps, MuscleGroup.shoulders],
);

List<WorkoutCategory> workoutCategories = [
  pushDay,
  pullDay,
  legDay,
  shoulderDay,
];
