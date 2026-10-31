part of 'register_cubit.dart';

enum RegisterStatus { initial, loading, success, failure }

class RegisterState extends Equatable {
  final RegisterData data;
  final BaseState registerState;
  final RegisterStatus status;

  const RegisterState({
    this.data = const RegisterData(),
    this.registerState = const BaseState.initial(),
    this.status = RegisterStatus.initial,
  });

  bool get isLoading =>
      status == RegisterStatus.loading || registerState.isLoading;
  bool get isSuccess => status == RegisterStatus.success;
  bool get isFailure =>
      status == RegisterStatus.failure || registerState.failure != null;
  AppFailure? get failure => registerState.failure;

  RegisterState copyWith({
    RegisterData? data,
    BaseState? registerState,
    RegisterStatus? status,
  }) {
    return RegisterState(
      data: data ?? this.data,
      registerState: registerState ?? this.registerState,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [data, registerState, status];
}

class RegisterData extends Equatable {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? password;
  final String? rePassword;
  final String? gender;
  final int? height;
  final int? weight;
  final int? age;
  final String? goal;
  final String? activityLevel;

  const RegisterData({
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.rePassword,
    this.gender,
    this.height,
    this.weight,
    this.age,
    this.goal,
    this.activityLevel,
  });

  bool get isBasicInfoComplete =>
      firstName != null &&
      firstName!.trim().isNotEmpty &&
      lastName != null &&
      lastName!.trim().isNotEmpty &&
      email != null &&
      email!.trim().isNotEmpty &&
      password != null &&
      password!.isNotEmpty;

  bool get isComplete =>
      isBasicInfoComplete &&
      gender != null &&
      gender!.trim().isNotEmpty &&
      height != null &&
      weight != null &&
      age != null &&
      goal != null &&
      goal!.trim().isNotEmpty &&
      activityLevel != null &&
      activityLevel!.trim().isNotEmpty;

  /// Maps the accumulated form data to [RegisterParams] for final registration
  RegisterParams? toParams() {
    if (!isComplete) return null;
    return RegisterParams(
      firstName: firstName!.trim(),
      lastName: lastName!.trim(),
      email: email!.trim(),
      password: password!,
      rePassword: rePassword ?? password!,
      gender: gender!.trim(),
      height: height!,
      weight: weight!,
      age: age!,
      goal: goal!.trim(),
      activityLevel: activityLevel!.trim(),
    );
  }

  /// Maps the accumulated form data to [RegisterDto] (delegates to [toParams])
  RegisterDto? toDto() {
    final params = toParams();
    return params != null ? RegisterDto.fromDomain(params) : null;
  }

  RegisterData copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? rePassword,
    String? gender,
    int? height,
    int? weight,
    int? age,
    String? goal,
    String? activityLevel,
  }) {
    return RegisterData(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      rePassword: rePassword ?? this.rePassword,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      age: age ?? this.age,
      goal: goal ?? this.goal,
      activityLevel: activityLevel ?? this.activityLevel,
    );
  }

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    password,
    rePassword,
    gender,
    height,
    weight,
    age,
    goal,
    activityLevel,
  ];
}
