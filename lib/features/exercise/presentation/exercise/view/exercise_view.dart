import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_view_mixin.dart';
import 'package:super_fitness/config/di/di.dart';
import 'package:super_fitness/features/exercise/presentation/exercise/manager/exercise_cubit.dart';

class ExerciseView extends StatefulWidget {
  final ExerciseCubit? cubit;
  const ExerciseView({super.key, this.cubit});

  @override
  State<ExerciseView> createState() => _ExerciseViewState();
}

class _ExerciseViewState extends State<ExerciseView>
    with BaseViewMixin<ExerciseView, ExerciseCubit, BaseEvent> {
  late final ExerciseCubit _cubit;
  bool _ownsCubit = false;

  @override
  ExerciseCubit get cubit => _cubit;

  @override
  void initState() {
    if (widget.cubit != null) {
      _cubit = widget.cubit!;
      _ownsCubit = false;
    } else if (getIt.isRegistered<ExerciseCubit>()) {
      _cubit = getIt<ExerciseCubit>();
      _ownsCubit = false;
    } else {
      _cubit = ExerciseCubit();
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
          child: BlocBuilder<ExerciseCubit, ExerciseState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return const Center(child: Text('Exercise Screen'));
            },
          ),
        ),
      ),
    );
  }
}

