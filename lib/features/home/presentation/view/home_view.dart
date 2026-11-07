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

  @override
  HomeCubit get cubit => _cubit;

  @override
  void initState() {
    _cubit = widget.cubit ?? getIt<HomeCubit>();
    super.initState();
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
