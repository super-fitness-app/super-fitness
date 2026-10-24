import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
  runApp(SuperFitnessApp(localeCubit: getIt<LocaleCubit>()));
}

class SuperFitnessApp extends StatelessWidget {
  final LocaleCubit? localeCubit;
  final GoRouter? router;

  const SuperFitnessApp({super.key, this.localeCubit, this.router});

  @override
  Widget build(BuildContext context) {
    final cubit = localeCubit ?? getIt<LocaleCubit>();
    return BlocProvider.value(
      value: cubit,
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp.router(
            onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            locale: locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            routerConfig: router ?? AppRouter.router,
          );
        },
      ),
    );
  }
}
