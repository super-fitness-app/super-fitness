import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_view_mixin.dart';
import 'package:super_fitness/config/di/di.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_images.dart';
import 'package:super_fitness/features/exercise/presentation/workout/manager/workout_cubit.dart';
import 'package:super_fitness/features/exercise/presentation/workout/view/widgets/workout_filter_chips.dart';
import 'package:super_fitness/features/exercise/presentation/workout/view/widgets/workout_grid.dart';

class WorkoutView extends StatefulWidget {
  const WorkoutView({super.key});

  @override
  State<WorkoutView> createState() => _WorkoutViewState();
}

class _WorkoutViewState extends State<WorkoutView>
    with BaseViewMixin<WorkoutView, WorkoutCubit, BaseEvent> {
  late final WorkoutCubit _cubit;

  @override
  WorkoutCubit get cubit => _cubit;

  @override
  void initState() {
    _cubit = getIt<WorkoutCubit>();
    super.initState();
    _cubit.doEvent(const FetchMuscleGroupsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: _WorkoutBody(cubit: _cubit),
      ),
    );
  }
}

class _WorkoutBody extends StatelessWidget {
  final WorkoutCubit cubit;

  const _WorkoutBody({required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _BackgroundImage(),
        _DarkOverlay(),
        SafeArea(
          child: BlocBuilder<WorkoutCubit, WorkoutState>(
            builder: (context, state) => _ContentColumn(
              state: state,
              cubit: cubit,
            ),
          ),
        ),
      ],
    );
  }
}

class _BackgroundImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppImages.workoutBackground,
      fit: BoxFit.cover,
    );
  }
}

class _DarkOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const ColoredBox(color: AppColors.overlay);
  }
}

class _ContentColumn extends StatelessWidget {
  final WorkoutState state;
  final WorkoutCubit cubit;

  const _ContentColumn({required this.state, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _WorkoutTitle(),
        const SizedBox(height: 20),
        if (state.data?.groups.isNotEmpty ?? false)
          WorkoutFilterChips(
            groups: state.data!.groups,
            selectedGroupId: state.data!.selectedGroupId,
            onSelected: (id) =>
                cubit.doEvent(SelectMuscleGroupEvent(id)),
          ),
        const SizedBox(height: 16),
        Expanded(child: _WorkoutScrollBody(state: state)),
      ],
    );
  }
}

class _WorkoutTitle extends StatelessWidget {
  const _WorkoutTitle();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 16),
      child: Text(
        'Workouts',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.white,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _WorkoutScrollBody extends StatelessWidget {
  final WorkoutState state;

  const _WorkoutScrollBody({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.isLoading && (state.data?.muscles.isEmpty ?? true)) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }
    if (state.failure != null && (state.data?.muscles.isEmpty ?? true)) {
      return Center(
        child: Text(
          state.errorMessage ?? 'Something went wrong',
          style: const TextStyle(color: AppColors.white),
        ),
      );
    }
    final muscles = state.data?.muscles ?? [];
    if (muscles.isEmpty) {
      return const Center(
        child: Text(
          'No exercises found',
          style: TextStyle(color: AppColors.grey30),
        ),
      );
    }
    return SingleChildScrollView(
      child: WorkoutGrid(muscles: muscles),
    );
  }
}
