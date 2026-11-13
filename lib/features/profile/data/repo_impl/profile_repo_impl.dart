import 'package:injectable/injectable.dart';
import 'package:super_fitness/features/profile/data/data_source/remote/profile_remote_data_source.dart';
import 'package:super_fitness/features/profile/domain/repo/profile_repo.dart';

@Injectable(as: ProfileRepo)
class ProfileRepoImpl implements ProfileRepo {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepoImpl(this._remoteDataSource);

  @override
  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    double? weight,
    String? goal,
    String? activityLevel,
  }) async {
    await _remoteDataSource.updateProfile(
      firstName: firstName,
      lastName: lastName,
      weight: weight,
      goal: goal,
      activityLevel: activityLevel,
    );
  }
}
