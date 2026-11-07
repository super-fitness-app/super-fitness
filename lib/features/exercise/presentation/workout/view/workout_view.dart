import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_view_mixin.dart';
import 'package:super_fitness/config/di/di.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_images.dart';
import 'package:super_fitness/features/exercise/domain/entities/muscle_entity.dart';
import 'package:super_fitness/features/exercise/presentation/workout/manager/workout_cubit.dart';
import 'package:super_fitness/features/exercise/presentation/workout/view/widgets/workout_filter_chips.dart';
import 'package:super_fitness/features/exercise/presentation/workout/view/widgets/workout_muscle_card.dart';

class WorkoutView extends StatefulWidget {
  final WorkoutCubit? cubit;
  const WorkoutView({super.key, this.cubit});

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
    _cubit = widget.cubit ?? getIt<WorkoutCubit>();
    super.initState();
    cubit.doEvent(const FetchMuscleGroupsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: _WorkoutBody(cubit: cubit),
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
            builder: (context, state) =>
                _WorkoutScrollView(state: state, cubit: cubit),
          ),
        ),
      ],
    );
  }
}

class _BackgroundImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(AppImages.workoutBackground, fit: BoxFit.cover);
  }
}

class _DarkOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const ColoredBox(color: AppColors.overlay);
  }
}

class _WorkoutScrollView extends StatelessWidget {
  final WorkoutState state;
  final WorkoutCubit cubit;

  const _WorkoutScrollView({required this.state, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final muscles = state.data?.muscles ?? [];
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _WorkoutHeader(state: state, cubit: cubit),
        ),
        _WorkoutContent(state: state, muscles: muscles),
      ],
    );
  }
}

class _WorkoutHeader extends StatelessWidget {
  final WorkoutState state;
  final WorkoutCubit cubit;

  const _WorkoutHeader({required this.state, required this.cubit});

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
            onSelected: (id) => cubit.doEvent(SelectMuscleGroupEvent(id)),
          ),
        const SizedBox(height: 16),
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

class _WorkoutContent extends StatelessWidget {
  final WorkoutState state;
  final List<MuscleEntity> muscles;

  const _WorkoutContent({required this.state, required this.muscles});

  @override
  Widget build(BuildContext context) {
    if (state.isLoading && muscles.isEmpty) {
      return const SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }
    if (state.failure != null && muscles.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Text(
            state.errorMessage ?? 'Something went wrong',
            style: const TextStyle(color: AppColors.white),
          ),
        ),
      );
    }
    if (muscles.isEmpty) {
      return const SliverFillRemaining(
        child: Center(
          child: Text(
            'No exercises found',
            style: TextStyle(color: AppColors.grey30),
          ),
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) => WorkoutMuscleCard(muscle: muscles[index]),
          childCount: muscles.length,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.85,
        ),
      ),
    );
  }
}
