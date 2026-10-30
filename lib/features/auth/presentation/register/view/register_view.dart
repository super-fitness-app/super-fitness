import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_view_mixin.dart';
import 'package:super_fitness/config/router/app_router.dart';
import 'package:super_fitness/core/const/app_images.dart';
import 'package:super_fitness/features/auth/presentation/register/manager/register_cubit.dart';
import 'widgets/register_form_card.dart';
import 'widgets/register_header.dart';

class RegisterView extends StatefulWidget {
  final RegisterCubit? cubit;
  const RegisterView({super.key, this.cubit});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView>
    with BaseViewMixin<RegisterView, RegisterCubit, BaseEvent> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final RegisterCubit _cubit;

  @override
  RegisterCubit get cubit => _cubit;

  @override
  void initState() {
    _cubit = widget.cubit ?? context.read<RegisterCubit>();
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      cubit.submitBasicInfoIntent(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  void _onLoginTap() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.login);
    }
  }

  void _onGoogleTap() {
    cubit.signInWithGoogleIntent();
  }

  @override
  Widget build(BuildContext context) {
    final content = Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppImages.authBackground, fit: BoxFit.cover),
          Container(color: const Color(0x801A1A1A)),
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: RegisterHeader(),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Form(
              key: _formKey,
              child: BlocBuilder<RegisterCubit, RegisterState>(
                bloc: widget.cubit != null ? _cubit : null,
                builder: (context, state) {
                  return RegisterFormCard(
                    firstNameController: _firstNameController,
                    lastNameController: _lastNameController,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    isLoading: state.isLoading,
                    onRegisterPressed: _onRegister,
                    onLoginTap: _onLoginTap,
                    onGoogleTap: _onGoogleTap,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );

    if (widget.cubit != null) {
      return BlocProvider.value(
        value: _cubit,
        child: content,
      );
    }

    return content;
  }
}
