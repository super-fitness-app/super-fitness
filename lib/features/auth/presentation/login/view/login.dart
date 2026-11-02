import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_view_mixin.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_images.dart';
import 'package:super_fitness/features/auth/presentation/login/cubit/login_cubit.dart';
import 'package:super_fitness/features/auth/presentation/login/view/widgets/login_card.dart';
import 'package:super_fitness/features/auth/presentation/login/view/widgets/login_header_section.dart';

class LoginView extends StatefulWidget {
  final LoginCubit? cubit;
  const LoginView({super.key, this.cubit});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with BaseViewMixin<LoginView, LoginCubit, BaseEvent> {
  @override
  LoginCubit get cubit => widget.cubit ?? context.read<LoginCubit>();

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold(
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
          const SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 12),
                  LoginHeaderSection(),
                  SizedBox(height: 28),
                  LoginCard(),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    if (widget.cubit != null) {
      return BlocProvider.value(value: widget.cubit!, child: scaffold);
    }
    return scaffold;
  }
}
