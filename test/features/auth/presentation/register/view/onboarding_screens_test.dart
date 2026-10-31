import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:super_fitness/config/base/base_state.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/config/l10n/app_localizations_en.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/router/app_router.dart';
import 'package:super_fitness/core/utils/password_generator.dart';
import 'package:super_fitness/features/auth/domain/entities/register_entity.dart';
import 'package:super_fitness/features/auth/domain/entities/register_params.dart';
import 'package:super_fitness/features/auth/domain/entities/social_auth_user_entity.dart';
import 'package:super_fitness/features/auth/domain/entities/user_entity.dart';
import 'package:super_fitness/features/auth/domain/repo/auth_repo.dart';
import 'package:super_fitness/features/auth/domain/use_cases/register_usecase.dart';
import 'package:super_fitness/features/auth/domain/use_cases/signin_with_google_usecase.dart';
import 'package:super_fitness/features/auth/presentation/register/manager/register_cubit.dart';
import 'package:super_fitness/features/auth/presentation/register/view/complete_register_view.dart';
import 'package:super_fitness/features/auth/presentation/register/view/select_activity_view.dart';
import 'package:super_fitness/features/auth/presentation/register/view/select_age_view.dart';
import 'package:super_fitness/features/auth/presentation/register/view/select_gender_view.dart';
import 'package:super_fitness/features/auth/presentation/register/view/select_goal_view.dart';
import 'package:super_fitness/features/auth/presentation/register/view/select_height_view.dart';
import 'package:super_fitness/features/auth/presentation/register/view/select_weight_view.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/gender_option_button.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/horizontal_number_picker.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/onboarding_bottom_button.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/onboarding_selectable_item.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/onboarding_top_bar.dart';

class FakeAuthRepo implements AuthRepo {
  ApiResults<RegisterEntity>? registerResultToReturn;
  RegisterParams? passedRequest;

  @override
  Future<ApiResults<RegisterEntity>> register(RegisterParams request) async {
    passedRequest = request;
    return registerResultToReturn ?? const FailureResponse(ServerMessageFailure(''));
  }

  @override
  Future<ApiResults<SocialAuthUserEntity>> signInWithGoogle() async {
    return const FailureResponse(ServerMessageFailure(''));
  }
}

Widget _wrapWithCubit(Widget child, RegisterCubit cubit) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: BlocProvider<RegisterCubit>.value(
      value: cubit,
      child: child,
    ),
  );
}

void main() {
  final l10n = AppLocalizationsEn();
  late RegisterCubit cubit;

  setUp(() {
    final fakeRepo = FakeAuthRepo();
    cubit = RegisterCubit(
      RegisterUseCase(fakeRepo),
      SignInWithGoogleUseCase(fakeRepo),
      const PasswordGenerator(),
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('SelectGenderView Widget Tests', () {
    testWidgets('renders all gender screen components correctly', (
      tester,
    ) async {
      await tester.pumpWidget(_wrapWithCubit(const SelectGenderView(), cubit));

      expect(find.text(l10n.tellUsAboutYourself), findsOneWidget);
      expect(find.text(l10n.weNeedToKnowYourGender), findsOneWidget);
      expect(find.byType(GenderOptionButton), findsNWidgets(2));
      expect(find.text(l10n.male), findsOneWidget);
      expect(find.text(l10n.female), findsOneWidget);
      expect(find.byType(OnboardingBottomButton), findsOneWidget);
    });

    testWidgets('toggles gender selection and enables next button', (
      tester,
    ) async {
      await tester.pumpWidget(_wrapWithCubit(const SelectGenderView(), cubit));

      final nextButton = tester.widget<ElevatedButton>(
        find.descendant(
          of: find.byType(OnboardingBottomButton),
          matching: find.byType(ElevatedButton),
        ),
      );
      expect(nextButton.onPressed, isNull);

      await tester.tap(find.text(l10n.male));
      await tester.pumpAndSettle();

      final enabledButton = tester.widget<ElevatedButton>(
        find.descendant(
          of: find.byType(OnboardingBottomButton),
          matching: find.byType(ElevatedButton),
        ),
      );
      expect(enabledButton.onPressed, isNotNull);
    });
  });

  group('SelectAgeView Widget Tests', () {
    testWidgets('renders age screen with horizontal picker', (
      tester,
    ) async {
      await tester.pumpWidget(_wrapWithCubit(const SelectAgeView(), cubit));

      expect(find.text(l10n.howOldAreYou), findsOneWidget);
      expect(find.text(l10n.personalizedPlanSubtitle), findsOneWidget);
      expect(find.byType(HorizontalNumberPicker), findsOneWidget);
      expect(find.text(l10n.year), findsOneWidget);
    });
  });

  group('SelectWeightView Widget Tests', () {
    testWidgets('renders weight screen with horizontal picker and Done button', (
      tester,
    ) async {
      await tester.pumpWidget(_wrapWithCubit(const SelectWeightView(), cubit));

      expect(find.text(l10n.whatIsYourWeight), findsOneWidget);
      expect(find.byType(HorizontalNumberPicker), findsOneWidget);
      expect(find.text(l10n.kg), findsOneWidget);
      expect(find.text(l10n.done), findsOneWidget);
    });
  });

  group('SelectHeightView Widget Tests', () {
    testWidgets('renders height screen with horizontal picker', (
      tester,
    ) async {
      await tester.pumpWidget(_wrapWithCubit(const SelectHeightView(), cubit));

      expect(find.text(l10n.whatIsYourHeight), findsOneWidget);
      expect(find.byType(HorizontalNumberPicker), findsOneWidget);
      expect(find.text(l10n.cm), findsOneWidget);
      expect(find.text(l10n.next), findsOneWidget);
    });
  });

  group('SelectGoalView Widget Tests', () {
    testWidgets('renders all 5 goal options and enables button on selection', (
      tester,
    ) async {
      await tester.pumpWidget(_wrapWithCubit(const SelectGoalView(), cubit));

      expect(find.text(l10n.whatIsYourGoal), findsOneWidget);
      expect(find.byType(OnboardingSelectableItem), findsNWidgets(5));
      expect(find.text(l10n.gainWeight), findsOneWidget);
      expect(find.text(l10n.loseWeight), findsOneWidget);

      await tester.tap(find.text(l10n.getFitter));
      await tester.pumpAndSettle();

      final button = tester.widget<ElevatedButton>(
        find.descendant(
          of: find.byType(OnboardingBottomButton),
          matching: find.byType(ElevatedButton),
        ),
      );
      expect(button.onPressed, isNotNull);
    });
  });

  group('SelectActivityView Widget Tests', () {
    testWidgets('renders all 5 activity level options and submits intent', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrapWithCubit(const SelectActivityView(), cubit),
      );

      expect(find.text(l10n.activityLevelTitle), findsOneWidget);
      expect(find.byType(OnboardingSelectableItem), findsNWidgets(5));
      expect(find.text(l10n.rookie), findsOneWidget);
      expect(find.text(l10n.beginner), findsOneWidget);
      expect(find.text(l10n.intermediate), findsOneWidget);
      expect(find.text(l10n.advance), findsOneWidget);
      expect(find.text(l10n.trueBeast), findsOneWidget);

      await tester.tap(find.text(l10n.intermediate));
      await tester.pumpAndSettle();

      final button = tester.widget<ElevatedButton>(
        find.descendant(
          of: find.byType(OnboardingBottomButton),
          matching: find.byType(ElevatedButton),
        ),
      );
      expect(button.onPressed, isNotNull);
    });
  });

  group('CompleteRegisterView Widget Tests', () {
    testWidgets('renders initial step SelectGenderView inside PageView', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrapWithCubit(const CompleteRegisterView(), cubit),
      );

      expect(find.byType(PageView), findsOneWidget);
      expect(find.byType(SelectGenderView), findsOneWidget);
      expect(find.text(l10n.tellUsAboutYourself), findsOneWidget);
    });

    testWidgets(
      'navigates sequentially through all 6 steps and verifies final submission button is enabled and callable',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          _wrapWithCubit(const CompleteRegisterView(), cubit),
        );

        // Step 1: Select Gender
        expect(find.byType(SelectGenderView), findsOneWidget);
        await tester.tap(find.text(l10n.male));
        await tester.pumpAndSettle();
        await tester.tap(find.text(l10n.next));
        await tester.pumpAndSettle();

        // Step 2: Select Age
        expect(find.byType(SelectAgeView), findsOneWidget);
        expect(find.text(l10n.howOldAreYou), findsOneWidget);
        await tester.tap(find.text(l10n.next));
        await tester.pumpAndSettle();

        // Step 3: Select Weight
        expect(find.byType(SelectWeightView), findsOneWidget);
        await tester.tap(find.text(l10n.done));
        await tester.pumpAndSettle();

        // Step 4: Select Height
        expect(find.byType(SelectHeightView), findsOneWidget);
        await tester.tap(find.text(l10n.next));
        await tester.pumpAndSettle();

        // Step 5: Select Goal
        expect(find.byType(SelectGoalView), findsOneWidget);
        await tester.tap(find.text(l10n.getFitter));
        await tester.pumpAndSettle();
        await tester.tap(find.text(l10n.next));
        await tester.pumpAndSettle();

        // Step 6: Select Activity Level
        expect(find.byType(SelectActivityView), findsOneWidget);
        expect(find.text(l10n.activityLevelTitle), findsOneWidget);

        // Verify final submission button is initially disabled
        final nextButtonBefore = tester.widget<ElevatedButton>(
          find.descendant(
            of: find.byType(OnboardingBottomButton),
            matching: find.byType(ElevatedButton),
          ),
        );
        expect(nextButtonBefore.onPressed, isNull);

        // Select an activity level
        await tester.tap(find.text(l10n.intermediate));
        await tester.pumpAndSettle();

        // Verify final submission button is now enabled and callable
        final nextButtonAfter = tester.widget<ElevatedButton>(
          find.descendant(
            of: find.byType(OnboardingBottomButton),
            matching: find.byType(ElevatedButton),
          ),
        );
        expect(nextButtonAfter.onPressed, isNotNull);

        // Call the final button
        await tester.tap(find.text(l10n.next));
        await tester.pumpAndSettle();

        // Verify cubit accumulated data across the full navigation chain
        expect(cubit.state.data.gender, 'male');
        expect(cubit.state.data.goal, l10n.getFitter);
        expect(cubit.state.data.activityLevel, 'level3');
      },
    );

    testWidgets(
      'tapping back button on step 2 returns to step 1',
      (tester) async {
        await tester.pumpWidget(
          _wrapWithCubit(const CompleteRegisterView(), cubit),
        );

        // Advance to Step 2
        await tester.tap(find.text(l10n.male));
        await tester.pumpAndSettle();
        await tester.tap(find.text(l10n.next));
        await tester.pumpAndSettle();

        expect(find.byType(SelectAgeView), findsOneWidget);

        // Tap back button
        final backButton = find.descendant(
          of: find.byType(OnboardingTopBar),
          matching: find.byType(IconButton),
        );
        await tester.tap(backButton.first);
        await tester.pumpAndSettle();

        expect(find.byType(SelectGenderView), findsOneWidget);
      },
    );

    testWidgets(
      'navigates through all 6 steps and submits final registration',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final fakeRepo = FakeAuthRepo();
        fakeRepo.registerResultToReturn = const Success(
          RegisterEntity(
            message: 'success',
            token: 'token123',
            user: UserEntity(
              firstName: 'John',
              lastName: 'Doe',
              email: 'john@example.com',
            ),
          ),
        );
        final testCubit = RegisterCubit(
          RegisterUseCase(fakeRepo),
          SignInWithGoogleUseCase(fakeRepo),
          const PasswordGenerator(),
        );

        // Pre-fill basic info into cubit
        testCubit.submitBasicInfoIntent(
          firstName: 'John',
          lastName: 'Doe',
          email: 'john@example.com',
          password: 'Password123!',
        );

        final router = GoRouter(
          initialLocation: AppRoutes.completeRegister,
          routes: [
            GoRoute(
              path: AppRoutes.completeRegister,
              builder: (context, state) => BlocProvider.value(
                value: testCubit,
                child: const CompleteRegisterView(),
              ),
            ),
            GoRoute(
              path: AppRoutes.login,
              builder: (context, state) => const Scaffold(
                body: Text('Login Screen Mock'),
              ),
            ),
          ],
        );

        await tester.pumpWidget(
          MaterialApp.router(
            routerConfig: router,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        );
        await tester.pumpAndSettle();

        // Step 1: Select Gender
        expect(find.byType(SelectGenderView), findsOneWidget);
        await tester.tap(find.text(l10n.male));
        await tester.pumpAndSettle();
        await tester.tap(find.text(l10n.next));
        await tester.pumpAndSettle();

        // Step 2: Select Age
        expect(find.byType(SelectAgeView), findsOneWidget);
        await tester.tap(find.text(l10n.next));
        await tester.pumpAndSettle();

        // Step 3: Select Weight
        expect(find.byType(SelectWeightView), findsOneWidget);
        await tester.tap(find.text(l10n.done));
        await tester.pumpAndSettle();

        // Step 4: Select Height
        expect(find.byType(SelectHeightView), findsOneWidget);
        await tester.tap(find.text(l10n.next));
        await tester.pumpAndSettle();

        // Step 5: Select Goal
        expect(find.byType(SelectGoalView), findsOneWidget);
        await tester.tap(find.text(l10n.getFitter));
        await tester.pumpAndSettle();
        await tester.tap(find.text(l10n.next));
        await tester.pumpAndSettle();

        // Step 6: Select Activity Level
        expect(find.byType(SelectActivityView), findsOneWidget);
        await tester.tap(find.text(l10n.intermediate));
        await tester.pumpAndSettle();

        // Submit on final step
        await tester.tap(find.text(l10n.next));
        await tester.pumpAndSettle();

        // Verify cubit state data
        expect(testCubit.state.data.gender, 'male');
        expect(testCubit.state.data.goal, l10n.getFitter);
        expect(testCubit.state.data.activityLevel, 'level3');
        expect(fakeRepo.passedRequest, isNotNull);
        expect(fakeRepo.passedRequest?.email, 'john@example.com');

        // Verify redirected to Login Screen Mock via BlocListener
        expect(find.text('Login Screen Mock'), findsOneWidget);

        testCubit.close();
      },
    );

    testWidgets(
      'displays error SnackBar when final registration fails',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final fakeRepo = FakeAuthRepo();
        fakeRepo.registerResultToReturn = const FailureResponse(
          ServerMessageFailure('Email already exists'),
        );
        final testCubit = RegisterCubit(
          RegisterUseCase(fakeRepo),
          SignInWithGoogleUseCase(fakeRepo),
          const PasswordGenerator(),
        );

        testCubit.submitBasicInfoIntent(
          firstName: 'John',
          lastName: 'Doe',
          email: 'john@example.com',
          password: 'Password123!',
        );

        final router = GoRouter(
          initialLocation: AppRoutes.completeRegister,
          routes: [
            GoRoute(
              path: AppRoutes.completeRegister,
              builder: (context, state) => BlocProvider.value(
                value: testCubit,
                child: const CompleteRegisterView(),
              ),
            ),
            GoRoute(
              path: AppRoutes.login,
              builder: (context, state) => const Scaffold(
                body: Text('Login Screen Mock'),
              ),
            ),
          ],
        );

        await tester.pumpWidget(
          MaterialApp.router(
            routerConfig: router,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        );
        await tester.pumpAndSettle();

        // Step 1: Gender
        await tester.tap(find.text(l10n.male));
        await tester.pumpAndSettle();
        await tester.tap(find.text(l10n.next));
        await tester.pumpAndSettle();

        // Step 2: Age
        await tester.tap(find.text(l10n.next));
        await tester.pumpAndSettle();

        // Step 3: Weight
        await tester.tap(find.text(l10n.done));
        await tester.pumpAndSettle();

        // Step 4: Height
        await tester.tap(find.text(l10n.next));
        await tester.pumpAndSettle();

        // Step 5: Goal
        await tester.tap(find.text(l10n.getFitter));
        await tester.pumpAndSettle();
        await tester.tap(find.text(l10n.next));
        await tester.pumpAndSettle();

        // Step 6: Activity Level
        await tester.tap(find.text(l10n.intermediate));
        await tester.pumpAndSettle();

        // Submit on final step
        await tester.tap(find.text(l10n.next));
        await tester.pumpAndSettle();

        // Verify SnackBar shown with error message
        expect(find.text('Email already exists'), findsOneWidget);
        // Verify NOT navigated to login
        expect(find.text('Login Screen Mock'), findsNothing);

        testCubit.close();
      },
    );

    testWidgets(
      'navigates to login on direct isSuccess transition without intermediate loading state',
      (tester) async {
        final fakeRepo = FakeAuthRepo();
        final testCubit = RegisterCubit(
          RegisterUseCase(fakeRepo),
          SignInWithGoogleUseCase(fakeRepo),
          const PasswordGenerator(),
        );

        final router = GoRouter(
          initialLocation: AppRoutes.completeRegister,
          routes: [
            GoRoute(
              path: AppRoutes.completeRegister,
              builder: (context, state) => BlocProvider.value(
                value: testCubit,
                child: const CompleteRegisterView(),
              ),
            ),
            GoRoute(
              path: AppRoutes.login,
              builder: (context, state) => const Scaffold(
                body: Text('Login Screen Mock'),
              ),
            ),
          ],
        );

        await tester.pumpWidget(
          MaterialApp.router(
            routerConfig: router,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        );
        await tester.pumpAndSettle();

        // Directly emit isSuccess from initial without going through loading
        testCubit.emit(
          testCubit.state.copyWith(
            registerState: BaseState.success(
              const RegisterEntity(
                message: 'success',
                token: 'tok',
                user: UserEntity(firstName: 'John', email: 'j@example.com'),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Must successfully navigate to login
        expect(find.text('Login Screen Mock'), findsOneWidget);

        testCubit.close();
      },
    );
  });
}
