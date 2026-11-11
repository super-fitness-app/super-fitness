import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/auth/domain/entities/login_entity.dart';
import 'package:super_fitness/features/auth/domain/entities/register_entity.dart';
import 'package:super_fitness/features/auth/domain/entities/register_params.dart';
import 'package:super_fitness/features/auth/domain/entities/social_auth_user_entity.dart';
import 'package:super_fitness/features/auth/domain/params/login_params.dart';
import 'package:super_fitness/features/auth/domain/repo/auth_repo.dart';
import 'package:super_fitness/features/auth/domain/use_cases/signin_with_facebook_usecase.dart';

class FakeAuthRepo implements AuthRepo {
  ApiResults<SocialAuthUserEntity>? facebookResultToReturn;

  @override
  Future<ApiResults<RegisterEntity>> register(RegisterParams request) async =>
      throw UnimplementedError();

  @override
  Future<ApiResults<SocialAuthUserEntity>> signInWithGoogle() async =>
      throw UnimplementedError();

  @override
  Future<ApiResults<SocialAuthUserEntity>> signInWithFacebook() async =>
      facebookResultToReturn!;

  @override
  Future<ApiResults<LoginEntity>> login(LoginParams params) async =>
      throw UnimplementedError();

  @override
  Future<ApiResults<void>> forgotPassword({required String email}) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResults<void>> resetPassword({
    required String otpToken,
    required String password,
    required String confirmPassword,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResults<Map<String, dynamic>>> verifyOtp({
    required String email,
    required String otp,
  }) {
    throw UnimplementedError();
  }
}

void main() {
  group('SignInWithFacebookUseCase Tests', () {
    late FakeAuthRepo fakeAuthRepo;
    late SignInWithFacebookUseCase signInWithFacebookUseCase;

    const testUser = SocialAuthUserEntity(
      id: 'facebook_user_123',
      email: 'facebook.user@example.com',
      displayName: 'Facebook User',
      photoUrl: 'https://example.com/fb.png',
    );

    setUp(() {
      fakeAuthRepo = FakeAuthRepo();
      signInWithFacebookUseCase = SignInWithFacebookUseCase(fakeAuthRepo);
    });

    test(
      'calls AuthRepo.signInWithFacebook and returns Success with SocialAuthUserEntity',
      () async {
        fakeAuthRepo.facebookResultToReturn = const Success(testUser);

        final result = await signInWithFacebookUseCase();

        expect(result, isA<Success<SocialAuthUserEntity>>());
        expect(
          (result as Success<SocialAuthUserEntity>).data,
          equals(testUser),
        );
      },
    );

    test(
      'returns FailureResponse when AuthRepo.signInWithFacebook fails',
      () async {
        const failure = ServerMessageFailure('Facebook authentication failed');
        fakeAuthRepo.facebookResultToReturn = const FailureResponse(failure);

        final result = await signInWithFacebookUseCase();

        expect(result, isA<FailureResponse<SocialAuthUserEntity>>());
        expect(
          (result as FailureResponse<SocialAuthUserEntity>).failure,
          equals(failure),
        );
      },
    );

    test(
      'returns Failure with CancelledFailure when user cancels Facebook sign-in',
      () async {
        const failure = CancelledFailure('Sign-in cancelled');
        fakeAuthRepo.facebookResultToReturn = const Failure(failure);

        final result = await signInWithFacebookUseCase();

        expect(result, isA<Failure<SocialAuthUserEntity>>());
        expect(
          (result as Failure<SocialAuthUserEntity>).failure,
          equals(failure),
        );
      },
    );
  });
}
