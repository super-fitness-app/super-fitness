import 'package:injectable/injectable.dart';

@injectable
class ProfileRemoteDataSource {
  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    double? weight,
    String? goal,
    String? activityLevel,
  }) async {}
}
