import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:royal_app/routing/routes.dart';
import 'package:royal_app/service/user_service.dart';

class AdColumnRight extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 500,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Text widget with information
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    // Add padding around the text
                    child: Text(
                      '¡Hola! Soy 🍅, seguidor de la Kings y Queens League.\n\n'
                      'Soy programador y decidí aportar mi granito de arena en esta liga de streamers.\n'
                      'He creado esta web para que jugadores, presidentes, creadores de contenido disfruten.\n\n'
                      '¡Espero que les guste! 😄',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _handleSignOut(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.red, // Background color of the button
                    ),
                    child: Text(
                      'Salir',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.transparent,
              child: Center(
                child: Text(
                  '',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSignOut(BuildContext context) async {
    final userService = Provider.of<UserService>(context, listen: false);
    await userService.signOut();
    Navigator.pushReplacementNamed(context, Routes.login);
  }
}
