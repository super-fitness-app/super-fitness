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

  @override
  ExerciseCubit get cubit => _cubit;

  @override
  void initState() {
    _cubit = widget.cubit ?? getIt<ExerciseCubit>();
    super.initState();
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
