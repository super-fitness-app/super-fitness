import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/profile/domain/entities/logout_entity.dart';
import 'package:super_fitness/features/profile/domain/repo/profile_repo.dart';

@injectable
class LogoutUseCase {
  final ProfileRepo _profileRepo;

  const LogoutUseCase(this._profileRepo);

  Future<ApiResults<LogoutEntity>> call() {
    return _profileRepo.logout();
  }
}