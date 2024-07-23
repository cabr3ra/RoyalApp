import 'package:flutter/material.dart';
import 'package:royal_app/constants/colors.dart';
import 'package:royal_app/firebase/auth_service.dart';
import 'package:royal_app/routing/routes.dart';
import 'package:royal_app/widgets/common/custom_buttons.dart';

class Login extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.colorPrimary,
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildLogo(context),
              const SizedBox(height: 80),
              _buildEmailTextField(),
              const SizedBox(height: 20),
              _buildPasswordTextField(),
              const SizedBox(height: 40),
              _buildLoginButton(context),
              const SizedBox(height: 10),
              _buildRegisterButton(context),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector _buildLogo(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, Routes.home);
      },
      child: Hero(
        tag: 'logoImage',
        child: Center(
          child: Image.asset(
            'assets/logo.png',
            width: 150,
            height: 150,
          ),
        ),
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
