import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_view_mixin.dart';
import 'package:super_fitness/config/di/di.dart';
import 'package:super_fitness/features/meals/presentation/food/manager/food_cubit.dart';

class FoodView extends StatefulWidget {
  final FoodCubit? cubit;
  const FoodView({super.key, this.cubit});

  @override
  State<FoodView> createState() => _FoodViewState();
}

class _FoodViewState extends State<FoodView>
    with BaseViewMixin<FoodView, FoodCubit, BaseEvent> {
  late final FoodCubit _cubit;

  @override
  FoodCubit get cubit => _cubit;

  @override
  void initState() {
    _cubit = widget.cubit ?? getIt<FoodCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<FoodCubit, FoodState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return const Center(child: Text('Food Screen'));
            },
          ),
        ),
      ),
    );
  }
}
