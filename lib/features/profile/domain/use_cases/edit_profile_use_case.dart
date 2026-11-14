import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/profile/domain/entities/edit_profile_entity.dart';
import 'package:super_fitness/features/profile/domain/params/edit_profile_params.dart';
import 'package:super_fitness/features/profile/domain/repo/profile_repo.dart';

@injectable
class EditProfileUseCase {
  final ProfileRepo _profileRepo;

  const EditProfileUseCase(this._profileRepo);

  Future<ApiResults<EditProfileEntity>> call(EditProfileParams params) {
    return _profileRepo.editProfile(params);
  }
}
