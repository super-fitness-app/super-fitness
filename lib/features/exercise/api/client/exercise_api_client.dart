import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'exercise_api_client.g.dart';

@singleton
@RestApi()
abstract class ExerciseApiClient {
  @factoryMethod
  factory ExerciseApiClient(Dio dio) = _ExerciseApiClient;
}

