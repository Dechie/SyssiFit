class AppFunctions {
  static String getImage(String workoutTitle) {
    String filename = workoutTitle
        .split(" ")
        .map((el) => el.toLowerCase())
        .join("");
    return "assets/images/$filename.jpg";
  }
}
