import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/auth/domain/entities/register_entity.dart';
import 'package:super_fitness/features/auth/domain/entities/register_params.dart';
import 'package:super_fitness/features/auth/domain/entities/social_auth_user_entity.dart';
import 'package:super_fitness/features/auth/domain/repo/auth_repo.dart';
import 'package:super_fitness/features/auth/domain/use_cases/signin_with_google_usecase.dart';

class FakeAuthRepo implements AuthRepo {
  ApiResults<SocialAuthUserEntity>? googleResultToReturn;

  @override
  Future<ApiResults<RegisterEntity>> register(RegisterParams request) async =>
      throw UnimplementedError();

  @override
  Future<ApiResults<SocialAuthUserEntity>> signInWithGoogle() async =>
      googleResultToReturn!;
}

void main() {
  group('SignInWithGoogleUseCase Tests', () {
    late FakeAuthRepo fakeAuthRepo;
    late SignInWithGoogleUseCase signInWithGoogleUseCase;

    const testUser = SocialAuthUserEntity(
      id: 'google_user_123',
      email: 'google.user@example.com',
      displayName: 'Google User',
      photoUrl: 'https://example.com/photo.png',
    );

    setUp(() {
      fakeAuthRepo = FakeAuthRepo();
      signInWithGoogleUseCase = SignInWithGoogleUseCase(fakeAuthRepo);
    });

    test(
      'calls AuthRepo.signInWithGoogle and returns Success with SocialAuthUserEntity',
      () async {
        fakeAuthRepo.googleResultToReturn = const Success(testUser);

        final result = await signInWithGoogleUseCase();

        expect(result, isA<Success<SocialAuthUserEntity>>());
        final success = result as Success<SocialAuthUserEntity>;
        expect(success.data, equals(testUser));
        expect(success.data.id, 'google_user_123');
        expect(success.data.email, 'google.user@example.com');
        expect(success.data.displayName, 'Google User');
        expect(success.data.photoUrl, 'https://example.com/photo.png');
      },
    );

    test('returns FailureResponse when AuthRepo.signInWithGoogle fails', () async {
      fakeAuthRepo.googleResultToReturn = const FailureResponse(
        ServerMessageFailure('Google sign-in failed'),
      );

      final result = await signInWithGoogleUseCase();

      expect(result, isA<FailureResponse<SocialAuthUserEntity>>());
      final failure = result as FailureResponse<SocialAuthUserEntity>;
      expect(failure.failure, isA<ServerMessageFailure>());
      expect(
        (failure.failure as ServerMessageFailure).message,
        'Google sign-in failed',
      );
    });

    test(
      'returns Failure with CancelledFailure when user cancels Google sign-in',
      () async {
        fakeAuthRepo.googleResultToReturn = const Failure(
          CancelledFailure('Sign in was cancelled by user'),
        );

        final result = await signInWithGoogleUseCase();

        expect(result, isA<Failure<SocialAuthUserEntity>>());
        final failure = result as Failure<SocialAuthUserEntity>;
        expect(failure.failure, isA<CancelledFailure>());
        expect(
          (failure.failure as CancelledFailure).message,
          'Sign in was cancelled by user',
        );
      },
    );
  });
}

