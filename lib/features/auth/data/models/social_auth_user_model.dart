import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:super_fitness/features/auth/domain/entities/social_auth_user_entity.dart';

part 'social_auth_user_model.g.dart';

SocialAuthUserModel socialAuthUserModelFromJson(String str) =>
    SocialAuthUserModel.fromJson(json.decode(str));

String socialAuthUserModelToJson(SocialAuthUserModel data) =>
    json.encode(data.toJson());

@JsonSerializable()
class SocialAuthUserModel extends Equatable {
  @JsonKey(name: "id")
  final String id;
  @JsonKey(name: "email")
  final String email;
  @JsonKey(name: "displayName")
  final String displayName;
  @JsonKey(name: "photoUrl")
  final String? photoUrl;

  const SocialAuthUserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
  });

  SocialAuthUserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
  }) => SocialAuthUserModel(
    id: id ?? this.id,
    email: email ?? this.email,
    displayName: displayName ?? this.displayName,
    photoUrl: photoUrl ?? this.photoUrl,
  );

  factory SocialAuthUserModel.fromJson(Map<String, dynamic> json) =>
      _$SocialAuthUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$SocialAuthUserModelToJson(this);

  // toEntity method to convert the model to an entity
  SocialAuthUserEntity toEntity() {
    return SocialAuthUserEntity(
      id: id,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
    );
  }

  @override
  List<Object?> get props => [id, email, displayName, photoUrl];
}
