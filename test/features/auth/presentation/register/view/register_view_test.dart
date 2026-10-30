import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/router/app_router.dart';
import 'package:super_fitness/core/const/app_strings.dart';
import 'package:super_fitness/features/auth/data/models/register_dto.dart';
import 'package:super_fitness/features/auth/domain/entities/register_entity.dart';
import 'package:super_fitness/features/auth/domain/repo/auth_repo.dart';
import 'package:super_fitness/features/auth/domain/use_cases/register_usecase.dart';
import 'package:super_fitness/features/auth/presentation/register/manager/register_cubit.dart';
import 'package:super_fitness/features/auth/presentation/register/view/register_view.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/already_have_account_row.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/register_header.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/register_password_field.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/register_text_field.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/social_auth_buttons.dart';

class FakeAuthRepo implements AuthRepo {
  @override
  Future<ApiResults<RegisterEntity>> register(RegisterDto request) async {
    return const FailureResponse(ServerMessageFailure(''));
  }
}

Widget _createTestWidget(RegisterCubit cubit) {
  final router = GoRouter(
    initialLocation: AppRoutes.register,
    routes: [
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => BlocProvider<RegisterCubit>.value(
          value: cubit,
          child: const RegisterView(),
        ),
      ),
      GoRoute(
        path: AppRoutes.completeRegister,
        builder: (context, state) => const SizedBox(),
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
  late RegisterCubit cubit;

  setUp(() {
    cubit = RegisterCubit(RegisterUseCase(FakeAuthRepo()));
  });

  tearDown(() {
    cubit.close();
  });

  group('RegisterView Widget Tests', () {
    testWidgets('renders all register screen components correctly', (
      tester,
    ) async {
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
        await tester.pumpWidget(_createTestWidget(cubit));

        await tester.enterText(find.byType(RegisterTextField).at(0), 'John');
        await tester.enterText(find.byType(RegisterTextField).at(1), 'Doe');
        await tester.enterText(
          find.byType(RegisterTextField).at(2),
          'invalid-email',
        );
        await tester.enterText(find.byType(RegisterTextField).at(3), 'short');

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
        await tester.pumpWidget(_createTestWidget(cubit));

        await tester.enterText(find.byType(RegisterTextField).at(0), 'John');
        await tester.enterText(find.byType(RegisterTextField).at(1), 'Doe');
        await tester.enterText(
          find.byType(RegisterTextField).at(2),
          'john.doe@example.com',
        );
        await tester.enterText(
          find.byType(RegisterTextField).at(3),
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
        await tester.pumpWidget(_createTestWidget(cubit));

        expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
        expect(find.byIcon(Icons.visibility_off_outlined), findsNothing);

        final toggleButton = find.descendant(
          of: find.byType(RegisterPasswordField),
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
  });
}
