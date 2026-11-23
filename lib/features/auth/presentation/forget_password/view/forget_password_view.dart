import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_view_mixin.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_images.dart';
import 'package:super_fitness/features/auth/presentation/forget_password/manager/forget_password_cubit.dart';
import 'package:super_fitness/features/auth/presentation/forget_password/manager/forget_password_event.dart';
import 'package:super_fitness/features/auth/presentation/forget_password/manager/forget_password_state.dart';
import 'package:super_fitness/features/auth/presentation/forget_password/view/widgets/forget_password_email.dart';
import 'package:super_fitness/features/auth/presentation/forget_password/view/widgets/forget_password_otp.dart';
import 'package:super_fitness/features/auth/presentation/forget_password/view/widgets/reset_password_view.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key, this.cubit});

  final ForgetPasswordCubit? cubit;

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView>
    with BaseViewMixin<ForgetPasswordView, ForgetPasswordCubit, BaseEvent> {
  late final PageController _pageController;
  late final ForgetPasswordCubit _cubit;

  // static const int _pageCount = 3;

  @override
  ForgetPasswordCubit get cubit => _cubit;

  @override
  void initState() {
    _cubit = widget.cubit ?? context.read<ForgetPasswordCubit>();

    super.initState();

    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppImages.background, fit: BoxFit.cover),
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(
                color: AppColors.background.withValues(alpha: 0.35),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              child: BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
                bloc: _cubit,
                builder: (context, state) {
                  return PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ForgetPasswordEmail(
                        isLoading:
                            state.isLoading &&
                            state.operation ==
                                ForgetPasswordOperation.checkEmail,
                        onSubmit: (email) {
                          _cubit.doEvent(CheckEmailEvent(email));
                        },
                      ),

                      const ForgetPasswordOtp(),

                      ResetPasswordView(
                        isLoading:
                            state.isLoading &&
                            state.operation ==
                                ForgetPasswordOperation.resetPassword,
                        onSubmit: (password) {
                          _cubit.doEvent(ResetPasswordEvent(password));
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
