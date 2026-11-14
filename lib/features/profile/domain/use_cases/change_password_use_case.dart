import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/profile/domain/entities/change_password_entity.dart';
import 'package:super_fitness/features/profile/domain/params/change_password_params.dart';
import 'package:super_fitness/features/profile/domain/repo/profile_repo.dart';

@injectable
class ChangePasswordUseCase {
  final ProfileRepo _profileRepo;

  const ChangePasswordUseCase(this._profileRepo);

  Future<ApiResults<ChangePasswordEntity>> call(ChangePasswordParams params) {
    return _profileRepo.changePassword(params);
  }
}
