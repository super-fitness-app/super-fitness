import 'package:injectable/injectable.dart';
import 'package:super_fitness/features/meals/data/data_source/remote/meals_remote_data_source.dart';
import 'package:super_fitness/features/meals/domain/repo/meals_repo.dart';

@Injectable(as: MealsRepo)
class MealsRepoImpl implements MealsRepo {
  final MealsRemoteDataSource _mealsRemoteDataSource;

  MealsRepoImpl(this._mealsRemoteDataSource);
  Future<MealsRemoteDataSource> getallhome() async {
    final response = _mealsRemoteDataSource;
    return response;
  }
}
