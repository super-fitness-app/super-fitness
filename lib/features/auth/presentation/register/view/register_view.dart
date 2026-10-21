import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:super_fitness/config/router/app_router.dart';
import 'package:super_fitness/core/const/app_images.dart';
import 'widgets/register_form_card.dart';
import 'widgets/register_header.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
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
      // Form is valid - trigger registration logic
    }
  }

  void _onLoginTap() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: RegisterFormCard(
                firstNameController: _firstNameController,
                lastNameController: _lastNameController,
                emailController: _emailController,
                passwordController: _passwordController,
                onRegisterPressed: _onRegister,
                onLoginTap: _onLoginTap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
