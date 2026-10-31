import 'package:injectable/injectable.dart';
import 'package:super_fitness/features/home/api/client/home_api_client.dart';
import 'package:super_fitness/features/home/data/data_source/remote/home_remote_data_source.dart';

@Injectable(as: HomeRemoteDataSource)
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final HomeApiClient _homeApiClient;

  HomeRemoteDataSourceImpl(this._homeApiClient);
    Future<HomeApiClient> getallhome() async {
    final response = _homeApiClient;
    return response;
  }
}
