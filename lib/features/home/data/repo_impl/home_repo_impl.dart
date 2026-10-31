import 'package:injectable/injectable.dart';
import 'package:super_fitness/features/home/data/data_source/remote/home_remote_data_source.dart';
import 'package:super_fitness/features/home/domain/repo/home_repo.dart';

@Injectable(as: HomeRepo)
class HomeRepoImpl implements HomeRepo {
  final HomeRemoteDataSource _homeRemoteDataSource;
//  remove this code when you merge code i add because when i push it appear warning 
  HomeRepoImpl(this._homeRemoteDataSource);
  Future<HomeRemoteDataSource> getallhome() async {
    final response = _homeRemoteDataSource;
    return response;
  }
}
