import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:super_fitness/config/l10n/app_localizations.dart';

import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_images.dart';

import 'package:super_fitness/features/auth/domain/entities/user_entity.dart';

import 'package:super_fitness/features/main_layout/profile/presentation/cubit/profile_cubit.dart';
import 'package:super_fitness/features/main_layout/profile/presentation/cubit/profile_event.dart';
import 'package:super_fitness/features/main_layout/profile/presentation/cubit/profile_state.dart';
import 'package:super_fitness/features/main_layout/profile/presentation/view/widgets/edit_profile_activity_view.dart';
import 'package:super_fitness/features/main_layout/profile/presentation/view/widgets/edit_profile_goal_view.dart';
import 'package:super_fitness/features/main_layout/profile/presentation/view/widgets/edit_profile_weight_view.dart';

import 'package:super_fitness/features/profile/domain/params/edit_profile_params.dart';

class EditProfileView extends StatefulWidget {
  final ProfileCubit? cubit;

  const EditProfileView({super.key, this.cubit});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  static const Color accentColor = Color(0xFFFF4500);

  late final ProfileCubit _cubit;

  AppLocalizations get l10n => AppLocalizations.of(context)!;

  final TextEditingController _firstNameController = TextEditingController();

  final TextEditingController _lastNameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  // Store weight as a numeric string.
  // The unit is added only when displaying it.
  String _weight = '';

  String _goal = '';
  String _activityLevel = '';

  bool _userInitialized = false;

  @override
  void initState() {
    super.initState();

    _cubit = widget.cubit ?? context.read<ProfileCubit>();

    _populateUserData(_cubit.state.user);
  }

  void _populateUserData(UserEntity? user) {
    if (user == null || _userInitialized) return;

    _firstNameController.text = user.firstName ?? '';
    _lastNameController.text = user.lastName ?? '';
    _emailController.text = user.email ?? '';

    _weight = user.weight?.toString() ?? '';
    _goal = user.goal ?? '';
    _activityLevel = user.activityLevel ?? '';

    _userInitialized = true;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();

    super.dispose();
  }

  // =========================
  // Submit Edit Profile
  // =========================

  void _submitEditProfile() {
    final user = _cubit.state.user;

    if (user == null) return;

    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();

    if (firstName.isEmpty || lastName.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.completeRequiredFields)));
      return;
    }

    final params = EditProfileParams(
      firstName: firstName,
      lastName: lastName,
      email: email,
      gender: user.gender,
      age: user.age,
      weight: double.tryParse(_weight.trim()),
      height: user.height,
      activityLevel: _activityLevel,
      goal: _goal,

      // Do not send photo.
      // The backend does not allow photo in this request.
    );

    _cubit.doEvent(SubmitEditProfileEvent(params));
  }

  Future<void> _editWeightPage() async {
    final result = await Navigator.of(context).push<int>(
      MaterialPageRoute(
        builder: (_) => EditProfileWeightView(
          initialWeight: double.tryParse(_weight)?.round() ?? 70,
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _weight = result.toString();
      });
    }
  }

  Future<void> _editGoalPage() async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => EditProfileGoalView(initialGoal: _goal),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _goal = result;
      });
    }
  }

  Future<void> _editActivityLevelPage() async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => EditProfileActivityView(initialLevel: _activityLevel),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _activityLevel = result;
      });
    }
  }
  // =========================
  // Build
  // =========================

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      bloc: _cubit,

      listener: (context, state) {
        // Handle user data loaded after initialization.
        if (!_userInitialized && state.user != null) {
          setState(() {
            _populateUserData(state.user);
          });
        }

        // Navigate back only when a new successful response arrives.
        if (state.editProfileApiState.data != null) {
          Navigator.maybePop(context);
        }
      },

      builder: (context, state) {
        final user = state.user;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(AppImages.background1, fit: BoxFit.cover),

              ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: Container(
                    color: AppColors.background.withValues(alpha: 0.35),
                  ),
                ),
              ),

              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Top Bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.maybePop(context),
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration: const BoxDecoration(
                                color: accentColor,
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                AppImages.back,
                                width: 36,
                                height: 36,
                              ),
                            ),
                          ),

                          Text(
                            l10n.editProfile,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(width: 38),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // Avatar
                      Center(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 116,
                              height: 116,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF4A251A),
                                  width: 2.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.45),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child:
                                    user?.photo != null &&
                                        user!.photo!.isNotEmpty
                                    ? Image.network(
                                        user.photo!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, _, _) => const Icon(
                                          Icons.person,
                                          size: 60,
                                          color: Colors.white54,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.person,
                                        size: 60,
                                        color: Colors.white54,
                                      ),
                              ),
                            ),

                            Positioned(
                              top: 2,
                              right: 2,
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF1A1A1A,
                                    ).withValues(alpha: 0.85),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: accentColor,
                                      width: 1.2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.edit_outlined,
                                    color: accentColor,
                                    size: 15,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Display Name
                      Center(
                        child: Text(
                          '${_firstNameController.text} '
                                  '${_lastNameController.text}'
                              .trim(),
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // First Name
                      _buildOutlinedTextField(
                        controller: _firstNameController,
                        icon: Icons.person_outline_rounded,
                        hint: l10n.firstName,
                      ),

                      const SizedBox(height: 16),

                      // Last Name
                      _buildOutlinedTextField(
                        controller: _lastNameController,
                        icon: Icons.person_outline_rounded,
                        hint: l10n.lastName,
                      ),

                      const SizedBox(height: 16),

                      // Email
                      _buildOutlinedTextField(
                        controller: _emailController,
                        icon: Icons.mail_outline_rounded,
                        hint: l10n.email,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 28),

                      // Weight
                      _buildSectionLabel(title: l10n.yourWeight),

                      const SizedBox(height: 8),

                      _buildTapToEditBox(
                        value: _weight.isEmpty
                            ? l10n.notSpecified
                            : '$_weight ${l10n.kgUnit}',
                        onTap: _editWeightPage,
                      ),

                      const SizedBox(height: 18),

                      // Goal
                      _buildSectionLabel(title: l10n.yourGoal),

                      const SizedBox(height: 8),

                      _buildTapToEditBox(
                        value: _localizedGoal(),
                        onTap: _editGoalPage,
                      ),

                      const SizedBox(height: 18),

                      // Activity Level
                      _buildSectionLabel(title: l10n.yourActivityLevel),

                      const SizedBox(height: 8),

                      _buildTapToEditBox(
                        value: _localizedActivityLevel(),
                        onTap: _editActivityLevelPage,
                      ),

                      const SizedBox(height: 30),

                      // Save Button
                      ElevatedButton(
                        onPressed: state.editProfileApiState.isLoading
                            ? null
                            : _submitEditProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor,
                          disabledBackgroundColor: accentColor.withValues(
                            alpha: 0.5,
                          ),
                          minimumSize: const Size(double.infinity, 52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: state.editProfileApiState.isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                l10n.saveChanges,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // =========================
  // Localized Goal
  // =========================

  String _localizedGoal() {
    if (_goal.isEmpty) return l10n.notSpecified;

    switch (_goal) {
      case 'Gain weight':
        return l10n.gainWeight;
      case 'Lose weight':
        return l10n.loseWeight;
      case 'Maintain weight':
        return l10n.maintainWeight;
      default:
        return _goal;
    }
  }

  // =========================
  // Localized Activity Level
  // =========================

  String _localizedActivityLevel() {
    if (_activityLevel.isEmpty) {
      return l10n.notSpecified;
    }

    switch (_activityLevel) {
      case 'Rookie':
        return l10n.rookie;
      case 'Beginner':
        return l10n.beginner;
      case 'Intermediate':
        return l10n.intermediate;
      case 'Advanced':
        return l10n.advanced;
      default:
        return _activityLevel;
    }
  }

  // =========================
  // Text Field
  // =========================

  Widget _buildOutlinedTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: (_) => setState(() {}),
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.85),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        prefixIcon: Icon(
          icon,
          color: Colors.white.withValues(alpha: 0.7),
          size: 20,
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.03),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.55),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: accentColor, width: 1.4),
        ),
      ),
    );
  }

  // =========================
  // Section Label
  // =========================

  Widget _buildSectionLabel({required String title}) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          children: [
            TextSpan(text: '$title ('),
            TextSpan(
              text: l10n.tapToEdit,
              style: const TextStyle(color: accentColor),
            ),
            const TextSpan(text: ')'),
          ],
        ),
      ),
    );
  }

  // =========================
  // Tap To Edit Box
  // =========================

  Widget _buildTapToEditBox({
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.55),
            width: 1,
          ),
        ),
        child: Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ),
    );
  }
}
