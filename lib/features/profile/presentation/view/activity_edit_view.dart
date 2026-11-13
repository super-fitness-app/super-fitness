import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_images.dart';
import 'package:super_fitness/core/const/app_text_styles.dart';
import 'package:super_fitness/features/profile/presentation/manager/profile_cubit.dart';

class ActivityEditView extends StatefulWidget {
  final String? initialActivity;
  final void Function(String)? onDone;

  const ActivityEditView({
    super.key,
    this.initialActivity,
    this.onDone,
  });

  @override
  State<ActivityEditView> createState() => _ActivityEditViewState();
}

class _ActivityEditViewState extends State<ActivityEditView> {
  static const List<String> _levels = [
    'Rookie',
    'Beginner',
    'Intermediate',
    'Advance',
    'True Beast',
  ];

  late String _selectedLevel;

  @override
  void initState() {
    super.initState();
    final cubitActivity =
        context.read<ProfileCubit?>()?.state.data?.activityLevel;
    _selectedLevel = widget.initialActivity ?? cubitActivity ?? _levels.first;
  }

  void _onDone() {
    final cubit = context.read<ProfileCubit?>();
    cubit?.doEvent(UpdateActivityEvent(_selectedLevel));
    widget.onDone?.call(_selectedLevel);
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppImages.authBackground, fit: BoxFit.cover),
          Container(color: AppColors.onboardingOverlay),
          SafeArea(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildTopBar(context),
                    const SizedBox(height: 18),
                    Image.asset(AppImages.superFitnessLogo, height: 42),
                    const SizedBox(height: 36),
                    Text(
                      'YOUR REGULAR PHYSICAL\nACTIVITY LEVEL ?',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bold20.copyWith(
                        color: AppColors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 28),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 35, sigmaY: 35),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                          decoration: BoxDecoration(
                            color: AppColors.onboardingCard,
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                              color: AppColors.white.withValues(alpha: 0.15),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ..._levels.map((lvl) => _buildOptionItem(lvl)),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: _onDone,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.orangeBase,
                                    foregroundColor: AppColors.white,
                                    shape: const StadiumBorder(),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    'Done',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () => Navigator.of(context).maybePop(),
        child: Image.asset(AppImages.back, width: 36, height: 36),
      ),
    );
  }

  Widget _buildOptionItem(String level) {
    final isSelected = _selectedLevel == level;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => setState(() => _selectedLevel = level),
        borderRadius: BorderRadius.circular(30),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.itemBorder,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isSelected ? AppColors.orangeBase : Colors.white24,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                level,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              _RadioIndicator(isSelected: isSelected),
            ],
          ),
        ),
      ),
    );
  }
}

class _RadioIndicator extends StatelessWidget {
  final bool isSelected;

  const _RadioIndicator({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppColors.orangeBase : Colors.white54,
          width: 2,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.orangeBase,
                ),
              ),
            )
          : null,
    );
  }
}
