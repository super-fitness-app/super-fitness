import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_state.dart';
import 'package:super_fitness/config/base/base_view_mixin.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/features/main_layout/body_layout/cubit/main_layout_cubit.dart';
import 'package:super_fitness/features/main_layout/body_layout/cubit/main_layout_intent.dart';
import 'package:super_fitness/features/main_layout/body_layout/view/widgets/floating_bottom_nav_bar.dart';
import 'package:super_fitness/features/main_layout/explore/explore_view.dart';
import 'package:super_fitness/features/main_layout/profile/profile_view.dart';
import 'package:super_fitness/features/main_layout/smart_coach/smart_coach_view.dart';
import 'package:super_fitness/features/main_layout/workout/workouts_view.dart';

class MainLayoutView extends StatefulWidget {
  final MainLayoutCubit? cubit;

  const MainLayoutView({super.key, this.cubit});

  @override
  State<MainLayoutView> createState() => _MainLayoutViewState();
}

class _MainLayoutViewState extends State<MainLayoutView>
    with BaseViewMixin<MainLayoutView, MainLayoutCubit, BaseEvent> {
  late final MainLayoutCubit _cubit;

  @override
  MainLayoutCubit get cubit => _cubit;

  @override
  void initState() {
    _cubit = widget.cubit ?? context.read<MainLayoutCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainLayoutCubit, BaseState<int>>(
      bloc: cubit,
      builder: (context, state) {
        final currentIndex = state.data ?? 0;

        return Scaffold(
          backgroundColor: AppColors.background,
          extendBody: true,
          body: IndexedStack(
            index: currentIndex,
            children: const [
              ExploreView(),
              SmartCoachView(),
              WorkoutsView(),
              ProfileView(),
            ],
          ),
          bottomNavigationBar: FloatingBottomNavBar(
            currentIndex: currentIndex,
            onTabSelected: (index) {
              cubit.doEvent(ChangeTabIntent(index));
            },
          ),
        );
      },
    );
  }
}
