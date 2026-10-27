import 'package:firebase_core/firebase_core.dart';
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
  await Firebase.initializeApp();
  Bloc.observer = AppBlocObserver();
  configureDependencies();
  runApp(SuperFitnessApp(localeCubit: getIt<LocaleCubit>()));
}

class SuperFitnessApp extends StatelessWidget {
  final LocaleCubit? localeCubit;

  const SuperFitnessApp({super.key, this.localeCubit});

  @override
  Widget build(BuildContext context) {
    final cubit = localeCubit ?? getIt<LocaleCubit>();
    return BlocProvider.value(
      value: cubit,
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp.router(
            onGenerateTitle: (context) =>
                AppLocalizations.of(context)!.appName,
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
