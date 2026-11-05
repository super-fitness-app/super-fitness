import 'package:injectable/injectable.dart';
import 'package:super_fitness/features/home/domain/repo/home_repo.dart';

@Injectable(as: HomeRepo)
class HomeRepoImpl implements HomeRepo {
  const HomeRepoImpl();
}
