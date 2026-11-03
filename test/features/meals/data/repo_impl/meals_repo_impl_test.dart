import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/network/app_error.dart';
import 'package:super_fitness/features/meals/data/data_source/remote/meals_remote_data_source.dart';
import 'package:super_fitness/features/meals/data/mapper/meals_mapper.dart';
import 'package:super_fitness/features/meals/data/models/categories_response.dart';
import 'package:super_fitness/features/meals/data/models/meals_details_response.dart';
import 'package:super_fitness/features/meals/data/models/meals_response.dart';
import 'package:super_fitness/features/meals/data/repo_impl/meals_repo_impl.dart';

class FakeMealsRemoteDataSource implements MealsRemoteDataSource {
  CategoriesResponse categoriesResponse = const CategoriesResponse(categories: []);
  MealsResponse mealsResponse = const MealsResponse(meals: []);
  MealDetailsResponse mealDetailsResponse = const MealDetailsResponse(meals: []);

  Exception? errorToThrow;

  @override
  Future<CategoriesResponse> getCategories() async {
    if (errorToThrow != null) throw errorToThrow!;
    return categoriesResponse;
  }

  @override
  Future<MealsResponse> getMealsByCategory(String category) async {
    if (errorToThrow != null) throw errorToThrow!;
    return mealsResponse;
  }

  @override
  Future<MealDetailsResponse> getMealDetails(String mealId) async {
    if (errorToThrow != null) throw errorToThrow!;
    return mealDetailsResponse;
  }
}

void main() {
  late FakeMealsRemoteDataSource remoteDataSource;
  late MealsMapper mapper;
  late MealsRepoImpl repo;

  setUp(() {
    remoteDataSource = FakeMealsRemoteDataSource();
    mapper = MealsMapper();
    repo = MealsRepoImpl(mapper, remoteDataSource);
  });

  group('MealsRepoImpl Tests', () {
    test('getCategories returns Success on successful dataSource fetch', () async {
      remoteDataSource.categoriesResponse = const CategoriesResponse(
        categories: [
          Category(id: '1', name: 'Seafood'),
        ],
      );

      final result = await repo.getCategories();

      expect(result, isA<Success>());
      final data = (result as Success).data;
      expect(data.length, 1);
      expect(data.first.name, 'Seafood');
    });

    test('getCategories returns Failure on DioException', () async {
      remoteDataSource.errorToThrow = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionError,
      );

      final result = await repo.getCategories();

      expect(result, isA<Failure>());
      final failure = (result as Failure).failure;
      expect(failure, isA<NetworkFailure>());
      expect((failure as NetworkFailure).error, AppError.noConnection);
    });

    test('getMealsByCategory returns Success on successful fetch', () async {
      remoteDataSource.mealsResponse = const MealsResponse(
        meals: [
          Meal(id: '10', name: 'Salmon Salad'),
        ],
      );

      final result = await repo.getMealsByCategory('Seafood');

      expect(result, isA<Success>());
      final data = (result as Success).data;
      expect(data.length, 1);
      expect(data.first.name, 'Salmon Salad');
    });

    test('getMealsByCategory returns Failure on unknown Exception', () async {
      remoteDataSource.errorToThrow = Exception('Network down');

      final result = await repo.getMealsByCategory('Seafood');

      expect(result, isA<Failure>());
      final failure = (result as Failure).failure;
      expect(failure, isA<NetworkFailure>());
      expect((failure as NetworkFailure).error, AppError.unknown);
    });

    test('getMealDetails returns Success when meal is found', () async {
      remoteDataSource.mealDetailsResponse = const MealDetailsResponse(
        meals: [
          MealDetails(id: '501', name: 'Grilled Fish'),
        ],
      );

      final result = await repo.getMealDetails('501');

      expect(result, isA<Success>());
      final data = (result as Success).data;
      expect(data.id, '501');
      expect(data.name, 'Grilled Fish');
    });

    test('getMealDetails returns Failure when meal is null or empty', () async {
      remoteDataSource.mealDetailsResponse = const MealDetailsResponse(meals: []);

      final result = await repo.getMealDetails('999');

      expect(result, isA<Failure>());
      final failure = (result as Failure).failure;
      expect(failure, isA<NetworkFailure>());
      expect((failure as NetworkFailure).error, AppError.server);
    });
  });
}
