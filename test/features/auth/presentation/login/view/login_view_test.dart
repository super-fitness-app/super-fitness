import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/router/app_router.dart';
import 'package:super_fitness/config/session/session_service.dart';
import 'package:super_fitness/core/ui/widgets/app_button.dart';
import 'package:super_fitness/core/ui/widgets/app_text_field.dart';
import 'package:super_fitness/features/auth/domain/entities/login_entity.dart';
import 'package:super_fitness/features/auth/domain/entities/user_entity.dart';
import 'package:super_fitness/features/auth/domain/params/login_params.dart';
import 'package:super_fitness/features/auth/domain/repo/auth_repo.dart';
import 'package:super_fitness/features/auth/domain/use_cases/login_use_case.dart';
import 'package:super_fitness/features/auth/presentation/login/cubit/login_cubit.dart';
import 'package:super_fitness/features/auth/presentation/login/view/login.dart';
import 'package:super_fitness/features/auth/presentation/login/view/widgets/forgot_password_button.dart';
import 'package:super_fitness/features/auth/presentation/login/view/widgets/login_card.dart';
import 'package:super_fitness/features/auth/presentation/login/view/widgets/login_footer.dart';
import 'package:super_fitness/features/auth/presentation/login/view/widgets/login_header_section.dart';

class _FakeAuthRepo implements AuthRepo {
  ApiResults<LoginEntity>? resultToReturn;

  @override
  Future<ApiResults<LoginEntity>> login(LoginParams params) async {
    return resultToReturn!;
  }
}

class _FakeSessionService implements SessionService {
  String? savedToken;

  @override
  Future<void> saveTokens({
    required String token,
    required String refreshToken,
    bool rememberMe = true,
  }) async {
    savedToken = token;
  }

  @override
  Future<void> clearSession() async {}
  @override
  Future<String> getRefreshToken() async => '';
  @override
  Future<String> getToken() async => savedToken ?? '';
  @override
  Future<bool> isGuest() async => false;
  @override
  Future<bool> isRemembered() async => true;
  @override
  Future<void> setGuestMode(bool value) async {}
  @override
  Future<void> setRememberMe(bool value) async {}
  @override
  Future<void> updateTokens({
    required String token,
    required String refreshToken,
  }) async {}
}

void main() {
  group('LoginView Widget Tests', () {
    late _FakeAuthRepo fakeAuthRepo;
    late _FakeSessionService fakeSessionService;
    late LoginUseCase loginUseCase;
    late LoginCubit cubit;

    setUp(() {
      fakeAuthRepo = _FakeAuthRepo();
      fakeSessionService = _FakeSessionService();
      loginUseCase = LoginUseCase(fakeAuthRepo);
      cubit = LoginCubit(loginUseCase, fakeSessionService);
    });

    tearDown(() async {
      await cubit.close();
    });

    Widget createTestApp(LoginCubit cubit) {
      final router = GoRouter(
        initialLocation: AppRoutes.login,
        routes: [
          GoRoute(
            path: AppRoutes.login,
            builder: (context, state) => BlocProvider<LoginCubit>.value(
              value: cubit,
              child: const LoginView(),
            ),
          ),
          GoRoute(
            path: AppRoutes.main,
            builder: (context, state) => const Scaffold(body: Text('Main')),
          ),
          GoRoute(
            path: AppRoutes.forgetPassword,
            builder: (context, state) =>
                const Scaffold(body: Text('ForgetPassword')),
          ),
          GoRoute(
            path: AppRoutes.register,
            builder: (context, state) => const Scaffold(body: Text('Register')),
          ),
        ],
      );

      return MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      );
    }

    testWidgets('renders all expected UI elements and excludes social logins',
        (tester) async {
      await tester.pumpWidget(createTestApp(cubit));
      await tester.pumpAndSettle();

      expect(find.byType(LoginHeaderSection), findsOneWidget);
      expect(find.byType(LoginCard), findsOneWidget);
      expect(find.byType(AppTextField), findsNWidgets(2));
      expect(find.byType(ForgotPasswordButton), findsOneWidget);
      expect(find.byType(AppButton), findsOneWidget);
      expect(find.byType(LoginFooter), findsOneWidget);

      expect(find.text('Or'), findsNothing);
      expect(find.text('Facebook'), findsNothing);
      expect(find.text('Google'), findsNothing);
      expect(find.text('Apple'), findsNothing);
    });

    testWidgets('toggles password visibility when eye icon tapped',
        (tester) async {
      await tester.pumpWidget(createTestApp(cubit));
      await tester.pumpAndSettle();

      final toggleFinder = find.byType(IconButton);
      expect(toggleFinder, findsOneWidget);

      await tester.tap(toggleFinder);
      await tester.pump();
      expect(cubit.state.isPasswordVisible, isTrue);

      await tester.tap(toggleFinder);
      await tester.pump();
      expect(cubit.state.isPasswordVisible, isFalse);
    });

    testWidgets('submitting invalid form shows validation error messages',
        (tester) async {
      await tester.pumpWidget(createTestApp(cubit));
      await tester.pumpAndSettle();

      final loginBtnFinder = find.byType(AppButton);
      await tester.tap(loginBtnFinder);
      await tester.pumpAndSettle();

      expect(cubit.state.emailError, isNotNull);
      expect(cubit.state.passwordError, isNotNull);
    });

    testWidgets('submitting valid credentials triggers loading state',
        (tester) async {
      final testUser = UserEntity(
        id: 'u1',
        firstName: 'Test',
        lastName: 'User',
        email: 'test@example.com',
        gender: 'male',
        age: 25,
        weight: 70,
        height: 175,
        activityLevel: 'mid',
        goal: 'gain',
        photo: 'pic.png',
        createdAt: DateTime(2025, 1, 1),
      );
      fakeAuthRepo.resultToReturn = Success<LoginEntity>(
        LoginEntity(
          message: 'OK',
          user: testUser,
          token: 'token_xyz',
        ),
      );

      await tester.pumpWidget(createTestApp(cubit));
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'test@example.com');
      await tester.enterText(textFields.at(1), 'ValidPass1');
      await tester.pump();

      await tester.tap(find.byType(AppButton));
      await tester.pumpAndSettle();

      expect(fakeSessionService.savedToken, 'token_xyz');
      expect(find.text('Main'), findsOneWidget);
    });
  });
}
