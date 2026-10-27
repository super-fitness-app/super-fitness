import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_view_mixin.dart';
import 'package:super_fitness/config/di/di.dart';
import 'package:super_fitness/features/home/presentation/manager/home_cubit.dart';

class HomeView extends StatefulWidget {
  final HomeCubit? cubit;
  const HomeView({super.key, this.cubit});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with BaseViewMixin<HomeView, HomeCubit, BaseEvent> {
  late final HomeCubit _cubit;
  bool _ownsCubit = false;

  @override
  HomeCubit get cubit => _cubit;

  @override
  void initState() {
    if (widget.cubit != null) {
      _cubit = widget.cubit!;
      _ownsCubit = false;
    } else if (getIt.isRegistered<HomeCubit>()) {
      _cubit = getIt<HomeCubit>();
      _ownsCubit = false;
    } else {
      _cubit = HomeCubit();
      _ownsCubit = true;
    }
    super.initState();
  }

  @override
  void dispose() {
    if (_ownsCubit) {
      _cubit.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return const Center(child: Text('Home Screen'));
            },
          ),
        ),
      ),
    );
  }
}
