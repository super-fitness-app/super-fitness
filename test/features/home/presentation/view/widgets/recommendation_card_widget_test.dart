import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/core/ui/themes/app_theme.dart';
import 'package:super_fitness/features/home/presentation/view/widgets/recommendation_card_widget.dart';

void main() {
  Widget buildWidget({
    required String title,
    required String imageUrl,
    VoidCallback? onTap,
    double width = 125,
    double height = 145,
  }) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      home: Scaffold(
        body: Center(
          child: RecommendationCardWidget(
            title: title,
            imageUrl: imageUrl,
            onTap: onTap,
            width: width,
            height: height,
          ),
        ),
      ),
    );
  }

  group('RecommendationCardWidget Tests', () {
    testWidgets('renders title and container structure', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          title: 'Push-Up',
          imageUrl: 'https://example.com/pushup.png',
        ),
      );
      await tester.pump();

      expect(find.text('Push-Up'), findsOneWidget);
      expect(find.byType(RecommendationCardWidget), findsOneWidget);
    });

    testWidgets('triggers onTap callback when tapped', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        buildWidget(
          title: 'Squat',
          imageUrl: 'https://example.com/squat.png',
          onTap: () {
            tapped = true;
          },
        ),
      );
      await tester.pump();

      await tester.tap(find.byType(RecommendationCardWidget));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('falls back to default image URL when imageUrl is empty', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget(title: 'Jogging', imageUrl: ''));
      await tester.pump();

      expect(find.text('Jogging'), findsOneWidget);
      final imageWidget = tester.widget<Image>(find.byType(Image));
      expect(imageWidget.image, isA<NetworkImage>());
    });
  });
}
