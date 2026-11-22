import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/session/session_service.dart';
import 'package:super_fitness/features/auth/data/data_source/local/auth_local_data_source.dart';

@Injectable(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SessionService _sessionService;

  AuthLocalDataSourceImpl(this._sessionService);

  @override
  Future<void> saveToken(String token) async {
    await _sessionService.saveTokens(token: token, refreshToken: '');
  }

  @override
  Future<String> getToken() => _sessionService.getToken();

  @override
  Future<void> clear() => _sessionService.clearSession();
}
