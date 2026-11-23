import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_view_mixin.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/config/router/app_router.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_images.dart';
import 'package:super_fitness/core/localization/locale_cubit.dart';

import 'package:super_fitness/features/main_layout/profile/presentation/cubit/profile_cubit.dart';
import 'package:super_fitness/features/main_layout/profile/presentation/cubit/profile_state.dart';
import 'package:super_fitness/features/main_layout/profile/presentation/cubit/profile_event.dart';
import 'package:super_fitness/config/di/di.dart';

import 'package:super_fitness/core/const/app_constants.dart';
import 'package:super_fitness/features/main_layout/profile/presentation/view/widgets/profile_card.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileView extends StatefulWidget {
  final ProfileCubit? cubit;

  const ProfileView({super.key, this.cubit});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with BaseViewMixin<ProfileView, ProfileCubit, BaseEvent> {
  late final ProfileCubit _cubit;
  bool _ownsCubit = false;

  @override
  ProfileCubit get cubit => _cubit;

  @override
  void initState() {
    if (widget.cubit != null) {
      _cubit = widget.cubit!;
      _ownsCubit = false;
    } else {
      try {
        _cubit = context.read<ProfileCubit>();
        _ownsCubit = false;
      } catch (_) {
        if (getIt.isRegistered<ProfileCubit>()) {
          _cubit = getIt<ProfileCubit>();
          _ownsCubit = false;
        } else {
          _cubit = ProfileCubit.dummy();
          _ownsCubit = true;
        }
      }
    }
    super.initState();

    // Load the user saved during login.
    _cubit.doEvent(const GetUserDataEvent());
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
    final content = BlocConsumer<ProfileCubit, ProfileState>(
      bloc: _cubit,
      listener: (context, state) {
        // Handle one-time UI effects through BaseViewMixin.
      },
      builder: (context, state) {
        final user = state.user;

        final fullName = [
          user?.firstName,
          user?.lastName,
        ].where((name) => name != null && name.isNotEmpty).join(' ');

        final photoUrl = user?.photo;

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
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.profile,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),

                    Container(
                      width: 118,
                      height: 118,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.orangeShade200,
                          width: 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withValues(alpha: 0.5),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: photoUrl != null && photoUrl.isNotEmpty
                            ? Image.network(
                                photoUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => Icon(
                                  Icons.person,
                                  size: 60,
                                  color: AppColors.grey30,
                                ),
                              )
                            : Icon(
                                Icons.person,
                                size: 60,
                                color: AppColors.grey30,
                              ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      fullName.isNotEmpty ? fullName : 'User',
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 8),

                    if (user?.email != null)
                      Text(
                        user!.email!,
                        style: TextStyle(fontSize: 14, color: AppColors.grey30),
                      ),

                    const SizedBox(height: 40),

                    ProfileSettingsCard(
                      onEditProfile: () {
                        context.push(AppRoutes.editProfile, extra: cubit);
                      },
                      onLogout: () {
                        _cubit.doEvent(const LogoutEvent());
                      },
                      onLanguageChanged: (value) {
                        getIt<LocaleCubit>().changeLocale(
                          Locale(
                            value
                                ? AppConstants.localeEnglish
                                : AppConstants.localeArabic,
                          ),
                        );
                      },
                      onChangePassword: () {
                        context.push(
                          AppRoutes.createNewPassword,
                          extra: context.read<ProfileCubit>(),
                        );
                      },
                      onHelp: () async {
                        final uri = Uri.parse(
                          'https://elevate-flutter-team.github.io/fitness-app-webviews/help.html',
                        );

                        if (await canLaunchUrl(uri)) {
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      },
                      onPrivacyPolicy: () async {
                        final uri = Uri.parse(
                          'https://elevate-flutter-team.github.io/fitness-app-webviews/privacy-policy.html',
                        );

                        if (await canLaunchUrl(uri)) {
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      },
                      onSecurity: () async {
                        final uri = Uri.parse(
                          'https://elevate-flutter-team.github.io/fitness-app-webviews/security.html',
                        );

                        if (await canLaunchUrl(uri)) {
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );

    return BlocProvider.value(value: _cubit, child: content);
  }
}
