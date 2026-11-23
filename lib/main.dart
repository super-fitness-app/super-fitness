import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:super_fitness/app_bloc_observer.dart';
import 'package:super_fitness/config/di/di.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/config/router/app_router.dart';
import 'package:super_fitness/core/localization/locale_cubit.dart';
import 'package:super_fitness/core/ui/themes/app_theme.dart';

import 'package:super_fitness/features/auth/presentation/login/cubit/login_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  configureDependencies();

  Bloc.observer = AppBlocObserver();

  runApp(SuperFitnessApp(localeCubit: getIt<LocaleCubit>()));
}

class SuperFitnessApp extends StatelessWidget {
  final LocaleCubit? localeCubit;
  final LoginCubit? loginCubit;
  final GoRouter? router;

  const SuperFitnessApp({
    super.key,
    this.localeCubit,
    this.loginCubit,
    this.router,
  });

  @override
  Widget build(BuildContext context) {
    final locale = localeCubit ?? getIt<LocaleCubit>();
    final authCubit = loginCubit ?? getIt<LoginCubit>();
    final appRouter = router ?? AppRouter.router;

    return MultiBlocProvider(
      providers: [
        BlocProvider<LocaleCubit>.value(value: locale),
        BlocProvider<LoginCubit>.value(value: authCubit),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
            theme: AppTheme.darkTheme,
            locale: locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
