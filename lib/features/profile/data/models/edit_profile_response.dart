
import 'package:json_annotation/json_annotation.dart';
import 'package:super_fitness/features/auth/data/models/login_response.dart';

part 'edit_profile_response.g.dart';

@JsonSerializable()
class EditProfileResponse {
  final String message;
  final LoginUser user;

  const EditProfileResponse({
    required this.message,
    required this.user,
  });

  factory EditProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$EditProfileResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$EditProfileResponseToJson(this);
}
