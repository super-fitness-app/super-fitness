import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_view_mixin.dart';
import 'package:super_fitness/config/di/di.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_images.dart';
import 'package:super_fitness/core/const/app_text_styles.dart';
import 'package:super_fitness/core/ui/widgets/app_text_field.dart';
import 'package:super_fitness/features/profile/presentation/manager/profile_cubit.dart';
import 'package:super_fitness/features/profile/presentation/view/activity_edit_view.dart';
import 'package:super_fitness/features/profile/presentation/view/goal_edit_view.dart';
import 'package:super_fitness/features/profile/presentation/view/weight_edit_view.dart';

class EditProfileView extends StatefulWidget {
  final ProfileCubit? cubit;
  const EditProfileView({super.key, this.cubit});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView>
    with BaseViewMixin<EditProfileView, ProfileCubit, BaseEvent> {
  late final ProfileCubit _cubit;
  bool _ownsCubit = false;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  ProfileCubit get cubit => _cubit;

  @override
  void initState() {
    if (widget.cubit != null) {
      _cubit = widget.cubit!;
      _ownsCubit = false;
    } else if (getIt.isRegistered<ProfileCubit>()) {
      _cubit = getIt<ProfileCubit>();
      _ownsCubit = false;
    } else {
      _cubit = ProfileCubit();
      _ownsCubit = true;
    }
    super.initState();
    final data = _cubit.state.data ?? const ProfileData();
    _firstNameController.text = data.firstName;
    _lastNameController.text = data.lastName;
    _emailController.text = data.email;
  }

  @override
  void dispose() {
    if (_ownsCubit) _cubit.close();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(AppImages.authBackground, fit: BoxFit.cover),
            Container(color: AppColors.onboardingOverlay),
            SafeArea(
              child: Column(
                children: [
                  _buildTopBar(context),
                  Expanded(
                    child: BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                        final data = state.data ?? const ProfileData();
                        return SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _buildAvatar('${data.firstName} ${data.lastName}'.trim()),
                              const SizedBox(height: 24),
                              AppTextField(
                                label: '',
                                hint: 'Ahmed',
                                controller: _firstNameController,
                                prefixIcon: const Icon(Icons.person_outline),
                                onChanged: _cubit.updateFirstName,
                              ),
                              const SizedBox(height: 12),
                              AppTextField(
                                label: '',
                                hint: 'Mohamed',
                                controller: _lastNameController,
                                prefixIcon: const Icon(Icons.person_outline),
                                onChanged: _cubit.updateLastName,
                              ),
                              const SizedBox(height: 12),
                              AppTextField(
                                label: '',
                                hint: 'Ahmed@Gmail',
                                controller: _emailController,
                                prefixIcon: const Icon(Icons.email_outlined),
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 20),
                              _buildTapField(
                                prefixLabel: 'Your Weihght ',
                                value: '${data.weight.toInt()} KG',
                                onTap: () => _openWeightScreen(context),
                              ),
                              const SizedBox(height: 14),
                              _buildTapField(
                                prefixLabel: 'Your Goal ',
                                value: data.goal,
                                onTap: () => _openGoalScreen(context),
                              ),
                              const SizedBox(height: 14),
                              _buildTapField(
                                prefixLabel: 'Your activity level ',
                                value: data.activityLevel,
                                onTap: () => _openActivityScreen(context),
                              ),
                              const SizedBox(height: 32),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Navigator.of(context).maybePop(),
              child: Image.asset(AppImages.back, width: 36, height: 36),
            ),
          ),
          Text(
            'Edit Profile',
            style: AppTextStyles.bold20.copyWith(color: AppColors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String name) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.grey70, width: 2),
                color: AppColors.surface,
              ),
              child: ClipOval(
                child: const Icon(
                  Icons.person,
                  size: 54,
                  color: AppColors.grey30,
                ),
              ),
            ),
            Positioned(
              top: 2,
              right: 2,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: AppColors.orangeBase,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.edit_outlined,
                  size: 14,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          name.isEmpty ? 'Ahmed Mohamed' : name,
          style: AppTextStyles.bold20.copyWith(color: AppColors.white),
        ),
      ],
    );
  }

  Widget _buildTapField({
    required String prefixLabel,
    required String value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: AppTextStyles.regular13.copyWith(color: AppColors.white),
            children: [
              TextSpan(text: prefixLabel),
              const TextSpan(
                text: '(tap To Edit)',
                style: TextStyle(
                  color: AppColors.orangeBase,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: AppColors.itemBorder,
              border: Border.all(color: Colors.white24),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              value,
              style: AppTextStyles.medium14.copyWith(color: AppColors.white),
            ),
          ),
        ),
      ],
    );
  }

  void _openWeightScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: _cubit,
          child: const WeightEditView(),
        ),
      ),
    );
  }

  void _openGoalScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: _cubit,
          child: const GoalEditView(),
        ),
      ),
    );
  }

  void _openActivityScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: _cubit,
          child: const ActivityEditView(),
        ),
      ),
    );
  }
}
