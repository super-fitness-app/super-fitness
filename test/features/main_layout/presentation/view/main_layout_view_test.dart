import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/const/app_dimensions.dart';
import 'package:super_fitness/core/const/app_icons.dart';
import 'package:super_fitness/core/ui/themes/app_theme.dart';
import 'package:super_fitness/features/main_layout/body_layout/cubit/main_layout_cubit.dart';
import 'package:super_fitness/features/main_layout/body_layout/view/main_layout_view.dart';
import 'package:super_fitness/features/main_layout/explore/explore_view.dart';
import 'package:super_fitness/features/main_layout/body_layout/view/widgets/floating_bottom_nav_bar.dart';
import 'package:super_fitness/features/main_layout/body_layout/view/widgets/nav_bar_item_widget.dart';
import 'package:super_fitness/features/main_layout/profile/profile_view.dart';
import 'package:super_fitness/features/main_layout/smart_coach/smart_coach_view.dart';
import 'package:super_fitness/features/main_layout/workout/workouts_view.dart';

Widget _buildTestApp({
  required MainLayoutCubit cubit,
  Locale locale = const Locale('en'),
}) {
  return MaterialApp(
    theme: AppTheme.darkTheme,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: locale,
    home: MainLayoutView(cubit: cubit),
  );
}

Finder _findTabByIcon(String iconPath) {
  return find.byWidgetPredicate(
    (w) =>
        w is Image &&
        w.image is AssetImage &&
        (w.image as AssetImage).assetName == iconPath,
  );
}

void main() {
  group('MainLayoutView & FloatingBottomNavBar Widget Tests', () {
    late MainLayoutCubit cubit;

    setUp(() {
      cubit = MainLayoutCubit();
    });

    tearDown(() async {
      await cubit.close();
    });

    testWidgets('renders 4 asset tabs, floating pill bar, and initial Explore tab',
        (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(_buildTestApp(cubit: cubit));
      await tester.pumpAndSettle();

      expect(find.byType(FloatingBottomNavBar), findsOneWidget);
      expect(find.byType(NavBarItemWidget), findsNWidgets(4));
      expect(find.byType(ExploreView), findsOneWidget);

      expect(_findTabByIcon(AppIcons.explore), findsOneWidget);
      expect(_findTabByIcon(AppIcons.smartCoach), findsOneWidget);
      expect(_findTabByIcon(AppIcons.workout), findsOneWidget);
      expect(_findTabByIcon(AppIcons.profile), findsOneWidget);

      expect(find.text('Explore'), findsNWidgets(2));
      expect(find.text('Smart Coach'), findsNothing);
      expect(find.text('Workouts'), findsNothing);
      expect(find.text('Profile'), findsNothing);
    });

    testWidgets('switches to Smart Coach tab when tapped', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(_buildTestApp(cubit: cubit));
      await tester.pumpAndSettle();

      await tester.tap(_findTabByIcon(AppIcons.smartCoach));
      await tester.pumpAndSettle();

      expect(cubit.state.data, equals(1));
      expect(find.byType(SmartCoachView), findsOneWidget);
      expect(find.text('Smart Coach'), findsNWidgets(2));
      expect(find.text('Workouts'), findsNothing);
    });

    testWidgets('switches to Workouts and Profile tabs', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(_buildTestApp(cubit: cubit));
      await tester.pumpAndSettle();

      await tester.tap(_findTabByIcon(AppIcons.workout));
      await tester.pumpAndSettle();

      expect(cubit.state.data, equals(2));
      expect(find.byType(WorkoutsView), findsOneWidget);
      expect(find.text('Workouts'), findsNWidgets(2));

      await tester.tap(_findTabByIcon(AppIcons.profile));
      await tester.pumpAndSettle();

      expect(cubit.state.data, equals(3));
      expect(find.byType(ProfileView), findsOneWidget);
      expect(find.text('Profile'), findsNWidgets(2));
    });

    testWidgets('renders on compact small screen (320dp width) without overflow',
        (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(_buildTestApp(cubit: cubit));
      await tester.pumpAndSettle();

      expect(find.byType(FloatingBottomNavBar), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('respects max-width bounds on tablet screen (800dp width)',
        (tester) async {
      tester.view.physicalSize = const Size(800, 1280);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(_buildTestApp(cubit: cubit));
      await tester.pumpAndSettle();

      final constrainedBox = tester.widget<ConstrainedBox>(
        find.byKey(const Key('floating_nav_bar_constrained_box')),
      );
      expect(
        constrainedBox.constraints.maxWidth,
        equals(AppDimensions.bottomNavBarMaxWidth),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders Arabic (RTL) localized content without overflow',
        (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(_buildTestApp(
        cubit: cubit,
        locale: const Locale('ar'),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(FloatingBottomNavBar), findsOneWidget);
      expect(find.text('استكشف'), findsNWidgets(2));
      expect(tester.takeException(), isNull);
    });
  });
}
