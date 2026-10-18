import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/base/base_cubit.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_view_mixin.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/errors/app_failure.dart';

class TestViewCubit extends BaseCubit<int, BaseEvent> {
  TestViewCubit() : super(0);

  @override
  void doEvent(Object event) {
    if (event is BaseEvent) {
      emitEvent(event);
    }
  }
}

class TestView extends StatefulWidget {
  final TestViewCubit cubit;
  const TestView({super.key, required this.cubit});

  @override
  State<TestView> createState() => _TestViewState();
}

class _TestViewState extends State<TestView>
    with BaseViewMixin<TestView, TestViewCubit, BaseEvent> {
  BaseEvent? receivedCustomEvent;

  @override
  TestViewCubit get cubit => widget.cubit;

  @override
  void onCustomEvent(BaseEvent event) {
    receivedCustomEvent = event;
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Test View Content')),
    );
  }
}

final class CustomTestEvent extends FeatureEvent {
  final String note;
  const CustomTestEvent(this.note);
}

void main() {
  group('BaseViewMixin Widget Tests', () {
    late TestViewCubit cubit;

    setUp(() {
      cubit = TestViewCubit();
    });

    tearDown(() async {
      await cubit.close();
    });

    Widget createTestApp(Widget child) {
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      );
    }

    testWidgets('displays success SnackBar when DisplaySuccess is emitted',
        (tester) async {
      await tester.pumpWidget(createTestApp(TestView(cubit: cubit)));
      await tester.pumpAndSettle();

      cubit.doEvent(const DisplaySuccess('Saved successfully'));
      await tester.pumpAndSettle();

      expect(find.text('Saved successfully'), findsOneWidget);

      final snackBarFinder = find.byType(SnackBar);
      expect(snackBarFinder, findsOneWidget);
      final snackBar = tester.widget<SnackBar>(snackBarFinder);
      expect(snackBar.backgroundColor, AppColors.success);
    });

    testWidgets('displays error SnackBar when DisplayError with message is emitted',
        (tester) async {
      await tester.pumpWidget(createTestApp(TestView(cubit: cubit)));
      await tester.pumpAndSettle();

      cubit.doEvent(const DisplayError('An error occurred'));
      await tester.pumpAndSettle();

      expect(find.text('An error occurred'), findsOneWidget);

      final snackBarFinder = find.byType(SnackBar);
      expect(snackBarFinder, findsOneWidget);
      final snackBar = tester.widget<SnackBar>(snackBarFinder);
      expect(snackBar.backgroundColor, AppColors.error);
    });

    testWidgets('displays localized error message when DisplayError with AppFailure is emitted',
        (tester) async {
      await tester.pumpWidget(createTestApp(TestView(cubit: cubit)));
      await tester.pumpAndSettle();

      cubit.doEvent(
        DisplayError.fromFailure(const ServerMessageFailure('Failed to connect')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Failed to connect'), findsOneWidget);
    });

    testWidgets('triggers onCustomEvent for custom feature events',
        (tester) async {
      await tester.pumpWidget(createTestApp(TestView(cubit: cubit)));
      await tester.pumpAndSettle();

      cubit.doEvent(const CustomTestEvent('custom_payload'));
      await tester.pump();

      final state = tester.state<_TestViewState>(find.byType(TestView));
      expect(state.receivedCustomEvent, isA<CustomTestEvent>());
      expect(
        (state.receivedCustomEvent as CustomTestEvent).note,
        'custom_payload',
      );
    });
  });
}
