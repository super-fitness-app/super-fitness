import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/router/app_router.dart';
import 'package:super_fitness/core/const/app_strings.dart';
import 'package:super_fitness/core/utils/password_generator.dart';
import 'package:super_fitness/features/auth/domain/entities/register_entity.dart';
import 'package:super_fitness/features/auth/domain/entities/register_params.dart';
import 'package:super_fitness/features/auth/domain/entities/social_auth_user_entity.dart';
import 'package:super_fitness/features/auth/domain/repo/auth_repo.dart';
import 'package:super_fitness/features/auth/domain/use_cases/register_usecase.dart';
import 'package:super_fitness/features/auth/domain/use_cases/signin_with_google_usecase.dart';
import 'package:super_fitness/features/auth/presentation/register/manager/register_cubit.dart';
import 'package:super_fitness/features/auth/presentation/register/view/register_view.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/already_have_account_row.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/register_fields.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/register_form_card.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/register_header.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/register_text_field.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/social_auth_buttons.dart';

class FakeAuthRepo implements AuthRepo {
  ApiResults<RegisterEntity>? registerResultToReturn;
  ApiResults<SocialAuthUserEntity>? googleResultToReturn;

  @override
  Future<ApiResults<RegisterEntity>> register(RegisterParams request) async =>
      registerResultToReturn ?? (throw UnimplementedError());

  @override
  Future<ApiResults<SocialAuthUserEntity>> signInWithGoogle() async =>
      googleResultToReturn ?? (throw UnimplementedError());
}

RegisterCubit createTestCubit([FakeAuthRepo? repo]) {
  final fakeRepo = repo ?? FakeAuthRepo();
  return RegisterCubit(
    RegisterUseCase(fakeRepo),
    SignInWithGoogleUseCase(fakeRepo),
    const PasswordGenerator(),
  );
}

Widget _createTestWidget(RegisterCubit testCubit) {
  final router = GoRouter(
    initialLocation: AppRoutes.register,
    routes: [
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => BlocProvider<RegisterCubit>.value(
          value: testCubit,
          child: RegisterView(cubit: testCubit),
        ),
      ),
      GoRoute(
        path: AppRoutes.completeRegister,
        builder: (context, state) => const Scaffold(
          body: Text('Complete Register Screen'),
        ),
      ),
    ],
  );

  return MaterialApp.router(
    routerConfig: router,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
  );
}

void main() {
  group('RegisterView Widget Tests', () {
    testWidgets(
      'reads cubit from BlocProvider when no cubit is passed to constructor',
      (tester) async {
        final testCubit = createTestCubit();
        addTearDown(testCubit.close);

        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: BlocProvider.value(
              value: testCubit,
              child: const RegisterView(),
            ),
          ),
        );

        expect(find.byType(RegisterView), findsOneWidget);
        expect(find.byType(RegisterHeader), findsOneWidget);
        expect(find.byType(RegisterFormCard), findsOneWidget);
      },
    );

    testWidgets('renders all register screen components correctly', (
      tester,
    ) async {
      final cubit = createTestCubit();
      addTearDown(cubit.close);

      await tester.pumpWidget(_createTestWidget(cubit));

      expect(find.byType(RegisterHeader), findsOneWidget);
      expect(find.text(AppStrings.heyThere), findsOneWidget);
      expect(find.text(AppStrings.createAnAccount), findsOneWidget);

      expect(find.text(AppStrings.register), findsNWidgets(2));

      expect(find.byType(RegisterTextField), findsNWidgets(4));
      expect(find.text(AppStrings.firstName), findsOneWidget);
      expect(find.text(AppStrings.lastName), findsOneWidget);
      expect(find.text(AppStrings.email), findsOneWidget);
      expect(find.text(AppStrings.password), findsOneWidget);

      expect(find.byType(SocialAuthButtons), findsOneWidget);
      expect(find.text(AppStrings.or), findsOneWidget);
      expect(find.byType(SocialIconButton), findsNWidgets(3));

      expect(find.byType(ElevatedButton), findsOneWidget);

      expect(find.byType(AlreadyHaveAccountRow), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is RichText &&
              widget.text.toPlainText().contains(AppStrings.login),
        ),
        findsOneWidget,
      );
    });

    testWidgets(
      'shows validation errors when Register is clicked with empty fields',
      (tester) async {
        final cubit = createTestCubit();
        addTearDown(cubit.close);

        await tester.pumpWidget(_createTestWidget(cubit));

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.text(AppStrings.firstNameRequired), findsOneWidget);
        expect(find.text(AppStrings.lastNameRequired), findsOneWidget);
        expect(find.text(AppStrings.invalidEmail), findsOneWidget);
        expect(find.text(AppStrings.passwordMinLength), findsOneWidget);
      },
    );

    testWidgets(
      'shows specific validation errors for invalid email and short password',
      (tester) async {
        final cubit = createTestCubit();
        addTearDown(cubit.close);

        await tester.pumpWidget(_createTestWidget(cubit));

        await tester.enterText(
          find.byKey(RegisterFieldsKeys.firstName),
          'John',
        );
        await tester.enterText(
          find.byKey(RegisterFieldsKeys.lastName),
          'Doe',
        );
        await tester.enterText(
          find.byKey(RegisterFieldsKeys.email),
          'invalid-email',
        );
        await tester.enterText(
          find.byKey(RegisterFieldsKeys.password),
          'short',
        );

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.text(AppStrings.firstNameRequired), findsNothing);
        expect(find.text(AppStrings.lastNameRequired), findsNothing);
        expect(find.text(AppStrings.invalidEmail), findsOneWidget);
        expect(find.text(AppStrings.passwordMinLength), findsOneWidget);
      },
    );

    testWidgets(
      'clears validation errors when valid text is entered into all fields',
      (tester) async {
        final cubit = createTestCubit();
        addTearDown(cubit.close);

        await tester.pumpWidget(_createTestWidget(cubit));

        await tester.enterText(
          find.byKey(RegisterFieldsKeys.firstName),
          'John',
        );
        await tester.enterText(
          find.byKey(RegisterFieldsKeys.lastName),
          'Doe',
        );
        await tester.enterText(
          find.byKey(RegisterFieldsKeys.email),
          'john.doe@example.com',
        );
        await tester.enterText(
          find.byKey(RegisterFieldsKeys.password),
          'Password123!',
        );

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.text(AppStrings.firstNameRequired), findsNothing);
        expect(find.text(AppStrings.lastNameRequired), findsNothing);
        expect(find.text(AppStrings.invalidEmail), findsNothing);
        expect(find.text(AppStrings.passwordMinLength), findsNothing);
      },
    );

    testWidgets(
      'toggles password visibility icon when suffix icon is tapped',
      (tester) async {
        final cubit = createTestCubit();
        addTearDown(cubit.close);

        await tester.pumpWidget(_createTestWidget(cubit));

        expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
        expect(find.byIcon(Icons.visibility_off_outlined), findsNothing);

        final toggleButton = find.descendant(
          of: find.byKey(RegisterFieldsKeys.password),
          matching: find.byType(IconButton),
        );
        await tester.tap(toggleButton);
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
        expect(find.byIcon(Icons.visibility_outlined), findsNothing);

        await tester.tap(toggleButton);
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
        expect(find.byIcon(Icons.visibility_off_outlined), findsNothing);
      },
    );

    testWidgets(
      'submits basic info intent and updates cubit state when form is valid',
      (tester) async {
        final cubit = createTestCubit();
        addTearDown(cubit.close);

        await tester.pumpWidget(_createTestWidget(cubit));

        await tester.enterText(
          find.byKey(RegisterFieldsKeys.firstName),
          'John',
        );
        await tester.enterText(
          find.byKey(RegisterFieldsKeys.lastName),
          'Doe',
        );
        await tester.enterText(
          find.byKey(RegisterFieldsKeys.email),
          'john.doe@example.com',
        );
        await tester.enterText(
          find.byKey(RegisterFieldsKeys.password),
          'Password123!',
        );

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(cubit.state.data.firstName, 'John');
        expect(cubit.state.data.lastName, 'Doe');
        expect(cubit.state.data.email, 'john.doe@example.com');
        expect(cubit.state.data.password, 'Password123!');
        expect(cubit.state.data.rePassword, 'Password123!');
      },
    );

    testWidgets(
      'submits basic info and navigates to completeRegister screen on valid form (happy path)',
      (tester) async {
        final fakeRepo = FakeAuthRepo();
        final cubit = createTestCubit(fakeRepo);
        addTearDown(cubit.close);

        await tester.pumpWidget(_createTestWidget(cubit));

        await tester.enterText(
          find.byKey(RegisterFieldsKeys.firstName),
          'John',
        );
        await tester.enterText(
          find.byKey(RegisterFieldsKeys.lastName),
          'Doe',
        );
        await tester.enterText(
          find.byKey(RegisterFieldsKeys.email),
          'john.doe@example.com',
        );
        await tester.enterText(
          find.byKey(RegisterFieldsKeys.password),
          'Password123!',
        );

        // Tap register button
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        // Verify cubit received form data
        expect(cubit.state.data.firstName, 'John');
        expect(cubit.state.data.lastName, 'Doe');
        expect(cubit.state.data.email, 'john.doe@example.com');
        expect(cubit.state.data.password, 'Password123!');

        // Verify happy path navigation to completeRegister route
        expect(find.text('Complete Register Screen'), findsOneWidget);
      },
    );

    testWidgets(
      'tapping google icon connects google account and redirects to complete register screen',
      (tester) async {
        final fakeRepo = FakeAuthRepo();
        fakeRepo.googleResultToReturn = const Success(
          SocialAuthUserEntity(
            id: 'google-user-123',
            email: 'google.user@example.com',
            displayName: 'Google User',
          ),
        );
        final testCubit = createTestCubit(fakeRepo);
        addTearDown(testCubit.close);

        await tester.pumpWidget(_createTestWidget(testCubit));

        // Find and tap the Google icon button using its semantic key
        final googleButton = find.byKey(SocialAuthKeys.google);
        await tester.tap(googleButton);
        await tester.pumpAndSettle();

        expect(find.text('Complete Register Screen'), findsOneWidget);
        expect(testCubit.state.data.email, 'google.user@example.com');
        expect(testCubit.state.data.firstName, 'Google');
        expect(testCubit.state.data.lastName, 'User');
      },
    );
  });

  group('AlreadyHaveAccountRow Tests', () {
    testWidgets(
      'renders localized text and calls onLoginTap when login text is tapped',
      (tester) async {
        var tapped = false;
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: AlreadyHaveAccountRow(onLoginTap: () => tapped = true),
            ),
          ),
        );

        expect(find.byType(AlreadyHaveAccountRow), findsOneWidget);
        final richTextFinder = find.byType(RichText);
        expect(richTextFinder, findsOneWidget);

        final richText = tester.widget<RichText>(richTextFinder);
        final textSpan = richText.text as TextSpan;
        expect(textSpan.text, 'Already Have An Account ? ');

        final loginSpan = textSpan.children!.first as TextSpan;
        expect(loginSpan.text, 'Login');
        expect(loginSpan.recognizer, isA<TapGestureRecognizer>());

        (loginSpan.recognizer! as TapGestureRecognizer).onTap?.call();
        expect(tapped, isTrue);
      },
    );
  });
}
