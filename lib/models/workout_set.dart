class WorkoutSet {
  int reps;
  // Consider adding weight: final double? weight;
  // Consider adding unit for weight: final String? weightUnit;

  WorkoutSet({this.reps = 0});
  factory WorkoutSet.fromJson(Map<String, dynamic> json) {
    return WorkoutSet(
      reps: json['reps'] as int,
      // weight: json['weight'] as double?,
      // weightUnit: json['weightUnit'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reps': reps,
      // 'weight': weight,
      // 'weightUnit': weightUnit,
    };
  }
}
