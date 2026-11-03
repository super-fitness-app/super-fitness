import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_view_mixin.dart';
import 'package:super_fitness/config/di/di.dart';
import 'package:super_fitness/features/meals/presentation/food_details/manager/food_details_cubit.dart';

class FoodDetailsView extends StatefulWidget {
  final FoodDetailsCubit? cubit;

  const FoodDetailsView({
    super.key,
    this.cubit,
  });

  @override
  State<FoodDetailsView> createState() => _FoodDetailsViewState();
}

class _FoodDetailsViewState extends State<FoodDetailsView>
    with BaseViewMixin<FoodDetailsView, FoodDetailsCubit, BaseEvent> {
  late final FoodDetailsCubit _cubit;
  bool _ownsCubit = false;

  @override
  FoodDetailsCubit get cubit => _cubit;

  @override
  void initState() {
    _initCubit();
    super.initState();
  }

  void _initCubit() {
    if (widget.cubit != null) {
      _cubit = widget.cubit!;
      _ownsCubit = false;
    } else if (getIt.isRegistered<FoodDetailsCubit>()) {
      _cubit = getIt<FoodDetailsCubit>();
      _ownsCubit = false;
    } else {
      _cubit = context.read<FoodDetailsCubit>();
      _ownsCubit = false;
    }
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
      child: const Scaffold(
        body: Center(
          child: Text('Food Details'),
        ),
      ),
    );
  }
}
