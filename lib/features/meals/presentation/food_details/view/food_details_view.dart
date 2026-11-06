import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_view_mixin.dart';
import 'package:super_fitness/config/di/di.dart';
import 'package:super_fitness/features/meals/presentation/food_details/manager/food_details_cubit.dart';

class FoodDetailsView extends StatefulWidget {
  final FoodDetailsCubit? cubit;
  const FoodDetailsView({super.key, this.cubit});

  @override
  State<FoodDetailsView> createState() => _FoodDetailsViewState();
}

class _FoodDetailsViewState extends State<FoodDetailsView>
    with BaseViewMixin<FoodDetailsView, FoodDetailsCubit, BaseEvent> {
  late final FoodDetailsCubit _cubit;

  @override
  FoodDetailsCubit get cubit => _cubit;

  @override
  void initState() {
    _cubit = widget.cubit ?? getIt<FoodDetailsCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<FoodDetailsCubit, FoodDetailsState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return const Center(child: Text('Food Details Screen'));
            },
          ),
        ),
      ),
    );
  }
}
