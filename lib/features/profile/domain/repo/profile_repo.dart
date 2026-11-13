abstract class ProfileRepo {
  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    double? weight,
    String? goal,
    String? activityLevel,
  });
}
