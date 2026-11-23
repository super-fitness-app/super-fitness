import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_view_mixin.dart';
import 'package:super_fitness/config/di/di.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
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
    cubit.doEvent(const FetchMuscleGroupsEvent());
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
          bottom: false,
          child: BlocBuilder<WorkoutCubit, WorkoutState>(
            bloc: cubit,
            builder: (context, state) => Column(
              children: [
                _WorkoutHeader(state: state, cubit: cubit),
                Expanded(
                  child: _WorkoutScrollView(state: state, cubit: cubit),
                ),
              ],
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
      slivers: [_WorkoutContent(state: state, muscles: muscles, cubit: cubit)],
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
    final canPop = Navigator.canPop(context);
    final l10n = AppLocalizations.of(context);
    final title = l10n?.workouts ?? 'Workouts';
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (canPop)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(start: 16),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: AppColors.white,
                  ),
                  onPressed: () => Navigator.maybePop(context),
                ),
              ),
            ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkoutContent extends StatelessWidget {
  final WorkoutState state;
  final List<MuscleEntity> muscles;
  final WorkoutCubit cubit;

  const _WorkoutContent({
    required this.state,
    required this.muscles,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    if (state.isLoading && muscles.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }
    if (state.failure != null && muscles.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                state.errorMessage ?? 'Something went wrong',
                style: const TextStyle(color: AppColors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                ),
                onPressed: () => cubit.doEvent(const FetchMuscleGroupsEvent()),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    if (muscles.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Text(
            'No exercises found',
            style: TextStyle(color: AppColors.grey30),
          ),
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
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
