import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/features/ai_chat/presentation/view/smart_coach_welcome_view.dart';
import 'package:super_fitness/features/ai_chat/presentation/view/widgets/welcome_glass_card.dart';
import 'package:super_fitness/features/ai_chat/presentation/view/widgets/welcome_top_bar.dart';

void main() {
  Widget buildTestableWidget({Widget? child}) {
    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ar')],
      home: child ?? const SmartCoachWelcomeView(),
    );
  }

  group('SmartCoachWelcomeView Widget Tests', () {
    testWidgets(
      'renders top bar, robot graphic, and glass card without crashing',
      (tester) async {
        await tester.pumpWidget(buildTestableWidget());
        await tester.pumpAndSettle();

        expect(find.byType(WelcomeTopBar), findsOneWidget);
        expect(find.byType(WelcomeGlassCard), findsOneWidget);
        expect(find.text('Get Started'), findsOneWidget);
        expect(find.text('I Am Your Smart Coach'), findsOneWidget);
      },
    );

    testWidgets('WelcomeGlassCard triggers onGetStarted callback on tap', (
      tester,
    ) async {
      var tapped = false;
      await tester.pumpWidget(
        buildTestableWidget(
          child: Scaffold(
            body: WelcomeGlassCard(
              onGetStarted: () {
                tapped = true;
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final buttonFinder = find.widgetWithText(ElevatedButton, 'Get Started');
      expect(buttonFinder, findsOneWidget);

      await tester.tap(buttonFinder);
      await tester.pump();

      expect(tapped, isTrue);
    });
  });
}
