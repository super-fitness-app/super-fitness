// ignore_for_file: unused_field

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:super_fitness/features/ai_chat/data/models/ai_request_model.dart';
import 'package:super_fitness/features/ai_chat/data/models/ai_response_model.dart';

abstract interface class AiRemoteDataSource {
  Future<AiResponseModel> sendChatRequest(AiRequestModel request);
}

@LazySingleton(as: AiRemoteDataSource)
class AiRemoteDataSourceImpl implements AiRemoteDataSource {
  final Dio _dio;

  const AiRemoteDataSourceImpl(this._dio);

  @override
  Future<AiResponseModel> sendChatRequest(AiRequestModel request) async {
    return const AiResponseModel(model: '');
  }
}
