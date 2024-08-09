import 'package:flutter/material.dart';
import 'package:royal_app/service/user_service.dart';
import 'package:royal_app/routing/routes.dart';
import 'package:royal_app/widgets/common/base_screen.dart';
import 'package:royal_app/widgets/common/custom_buttons.dart';

class Login extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final UserService _authService = UserService();

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      bodyContent: [
        const SizedBox(height: 60),
        _buildLogo(),
        const SizedBox(height: 80),
        _buildEmailTextField(),
        const SizedBox(height: 20),
        _buildPasswordTextField(),
        const SizedBox(height: 40),
        _buildLoginButton(context),
        const SizedBox(height: 10),
        _buildRegisterButton(context),
      ],
    );
  }

  Center _buildLogo() {
    return Center(
      child: Image.asset(
        'assets/logo.png',
        width: 150,
        height: 150,
      ),
    );
  }

  SizedBox _buildEmailTextField() {
    return SizedBox(
      width: 250,
      height: 40,
      child: TextField(
        controller: emailController,
        decoration: InputDecoration(
          labelText: 'Correo electrónico',
          labelStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
        ),
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  SizedBox _buildPasswordTextField() {
    return SizedBox(
      width: 250,
      height: 40,
      child: TextField(
        controller: passwordController,
        decoration: InputDecoration(
          labelText: 'Contraseña',
          labelStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
        ),
        obscureText: true,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  CustomButton _buildLoginButton(BuildContext context) {
    return CustomButton(
      icon: Icons.login,
      text: 'Iniciar Sesión',
      onPressed: () async {
        final String? errorMessage = await _authService.signIn(
          emailController.text,
          passwordController.text,
        );
        if (errorMessage == null) {
          Navigator.pushReplacementNamed(context, Routes.home);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      },
    );
  }

  Center _buildRegisterButton(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.register);
        },
        child: Text(
          '¿No tienes cuenta? Regístrate aquí',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
