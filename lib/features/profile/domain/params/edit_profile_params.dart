class EditProfileParams {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? gender;
  final int? age;
  final double? weight;
  final double? height;
  final String? activityLevel;
  final String? goal;
  final String? photo;

  const EditProfileParams({
    this.firstName,
    this.lastName,
    this.email,
    this.gender,
    this.age,
    this.weight,
    this.height,
    this.activityLevel,
    this.goal,
    this.photo,
  });
}
