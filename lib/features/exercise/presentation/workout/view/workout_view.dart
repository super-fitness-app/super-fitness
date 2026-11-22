import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_view_mixin.dart';
import 'package:super_fitness/config/di/di.dart';
import 'package:super_fitness/features/exercise/presentation/workout/manager/workout_cubit.dart';

class WorkoutView extends StatefulWidget {
  final WorkoutCubit? cubit;
  const WorkoutView({super.key, this.cubit});

  @override
  State<WorkoutView> createState() => _WorkoutViewState();
}

class _WorkoutViewState extends State<WorkoutView>
    with BaseViewMixin<WorkoutView, WorkoutCubit, BaseEvent> {
  late final WorkoutCubit _cubit;
  bool _ownsCubit = false;

  @override
  WorkoutCubit get cubit => _cubit;

  @override
  void initState() {
    if (widget.cubit != null) {
      _cubit = widget.cubit!;
      _ownsCubit = false;
    } else if (getIt.isRegistered<WorkoutCubit>()) {
      _cubit = getIt<WorkoutCubit>();
      _ownsCubit = false;
    } else {
      _cubit = WorkoutCubit();
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
          child: BlocBuilder<WorkoutCubit, WorkoutState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return const Center(child: Text('Workout Screen'));
            },
          ),
        ),
      ),
    );
  }
}
