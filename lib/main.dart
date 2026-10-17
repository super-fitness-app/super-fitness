import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_fitness/app_bloc_observer.dart';
import 'package:super_fitness/config/router/app_router.dart';
import 'package:super_fitness/config/di/di.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/localization/locale_cubit.dart';
import 'package:super_fitness/core/ui/themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  configureDependencies();
  runApp(const SuperFitnessApp());
}

class SuperFitnessApp extends StatelessWidget {
  const SuperFitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LocaleCubit>(),
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp.router(
            title: 'Super Fitness',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            locale: locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
